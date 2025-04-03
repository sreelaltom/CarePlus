import os
import io
import json
import requests
import re
import pdfplumber
import pytesseract
from PIL import Image
from dotenv import load_dotenv
from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import CancerPrediction, MedicalFile, MedicalReport, Investigation
from .cloudinary_helper import upload_file

load_dotenv()

User = get_user_model()

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    email = serializers.EmailField(allow_null=True, required=False)  # Allow null email for doctors

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'is_patient', 'is_doctor', 'registration_id', 'phone_number']

    def validate(self, data):
        """Custom validation to return errors in a consistent format."""
        errors = {}

        if 'username' in data and User.objects.filter(username=data['username']).exists():
            errors["username"] = "A user with that username already exists."

        if 'email' in data and data['email'] and User.objects.filter(email=data['email']).exists():
            errors["email"] = "A user with that email already exists."

        if errors:
            raise serializers.ValidationError(errors)
        
        return data

    def create(self, validated_data):
        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user

def extract_json_from_response(response_text):
    """Extracts the JSON part from a text response using regex."""
    json_match = re.search(r'\{.*\}', response_text, re.DOTALL)
    if json_match:
        try:
            return json.loads(json_match.group(0))
        except json.JSONDecodeError:
            return {"error": "Invalid JSON format extracted"}
    return {"error": "No JSON found in response"}

def extract_text_from_file(file):
    extracted_text = ""
    file_extension = file.name.split(".")[-1].lower()

    try:
        if file_extension in ["jpg", "jpeg", "png", "tiff", "bmp"]:
            image = Image.open(io.BytesIO(file.read()))
            extracted_text = pytesseract.image_to_string(image)
        elif file_extension == "pdf":
            extracted_text_list = []
            with pdfplumber.open(file) as pdf:
                for page in pdf.pages:
                    text = page.extract_text()
                    if text:
                        extracted_text_list.append(text)
            extracted_text = "\n".join(extracted_text_list) if extracted_text_list else "No text found"
    except Exception as e:
        return f"Error extracting text: {str(e)}"

    OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")
    if not OPENROUTER_API_KEY:
        return "Error: OpenRouter API key not found."

    try:
        response = requests.post(
            url="https://openrouter.ai/api/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {OPENROUTER_API_KEY}",
                "Content-Type": "application/json",
            },
            json={
                "model": "mistralai/mistral-small-3.1-24b-instruct:free",
                "messages": [
                    {
                        "role": "user",
                        "content": [
                            {
                                "type": "text",
                                "text": "Extract and structure the following medical text into the following JSON format: \n"
                                        "{\n"
                                        '    "patient_name": "",\n'
                                        '    "age": ,\n'
                                        '    "gender": "",\n'
                                        '    "hospital_name": "",\n'
                                        '    "report_id": "",\n'
                                        '    "investigations": [\n'
                                        '        {\n'
                                        '            "test_name": "",\n'
                                        '            "observed_value": ,\n'
                                        '            "units": "",\n'
                                        '            "reference_range": ""\n'
                                        '        }\n'
                                        "    ]\n"
                                        "}\n"
                                        "Ensure that all values are extracted accurately and maintain their proper structure."
                            },
                            {"type": "text", "text": extracted_text}
                        ]
                    }
                ]
            }
        )
        response_data = response.json()
        structured_text = response_data.get("choices", [{}])[0].get("message", {}).get("content", "No structured data returned")
    except Exception as e:
        structured_text = f"Error processing text with LLM: {str(e)}"
    
    return extract_json_from_response(structured_text)

class MedicalFileSerializer(serializers.ModelSerializer):
    class Meta:
        model = MedicalFile
        fields = ['id', 'file', 'cloudinary_url', 'file_type', 'uploaded_at', 'structured_text']

    def create(self, validated_data):
        file = validated_data.pop("file")
        cloudinary_url = upload_file(file)
        file.seek(0)
        extracted_text = extract_text_from_file(file)
        print(extracted_text)
        
        medical_file = MedicalFile.objects.create(
            cloudinary_url=cloudinary_url,
            structured_text=extracted_text,
            **validated_data
        )
        return medical_file

class MedicalReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = MedicalReport
        fields = '__all__'

class InvestigationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Investigation
        fields = '__all__'

class CancerPredictionSerializer(serializers.ModelSerializer):
    class Meta:
        model = CancerPrediction
        fields = ["id", "user", "image_url", "prediction", "uploaded_at"]
