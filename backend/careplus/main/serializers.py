from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import MedicalFile
from .cloudinary_helper import upload_file
import pytesseract
import pdfplumber  # More efficient than pdf2image
from PIL import Image
import io


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

        if data.get('username') and  User.objects.filter(username=data['username']).exists():
            errors["error"] = "A user with that username already exists."

        if data.get('email') and User.objects.filter(email=data['email']).exists():
            errors["error"] = "A user with that email already exists."

        if errors:
            raise serializers.ValidationError(errors)

        return data

    def create(self, validated_data):
        """Create and return a new user."""
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data.get('email', None),
            password=validated_data['password'],
            is_patient=validated_data.get('is_patient', False),
            is_doctor=validated_data.get('is_doctor', False),
            registration_id=validated_data.get('registration_id', None),
            phone_number=validated_data.get('phone_number', None),
        )
        return user
def extract_text_from_file(file):
    """
    Extracts text from both PDFs and images.
    - Uses `pdfplumber` for PDFs
    - Uses `pytesseract` for image files
    """
    extracted_text = ""

    # Get file extension
    file_extension = file.name.split(".")[-1].lower()

    try:
        if file_extension in ["jpg", "jpeg", "png", "tiff", "bmp"]:
            # Process images with OCR
            image = Image.open(io.BytesIO(file.read()))  # Read image from file
            extracted_text = pytesseract.image_to_string(image)

        elif file_extension == "pdf":
            # Process PDFs
            extracted_text_list = []
            with pdfplumber.open(file) as pdf:
                for page in pdf.pages:
                    text = page.extract_text()
                    if text:
                        extracted_text_list.append(text)
            
            extracted_text = "\n".join(extracted_text_list) if extracted_text_list else "No text found"

    except Exception as e:
        extracted_text = f"Error extracting text: {str(e)}"

    return extracted_text

class MedicalFileSerializer(serializers.ModelSerializer):
    class Meta:
        model = MedicalFile
        fields = ['id', 'file', 'cloudinary_url', 'file_type', 'uploaded_at']

    def create(self, validated_data):
        """Upload file to Cloudinary and save URL in the model."""
        file = validated_data.pop("file") 
        cloudinary_url = upload_file(file)  
        file.seek(0)  # Reset file pointer before reading again

        # Extract text if it's an image or PDF
        extracted_text = extract_text_from_file(file)
        print("Extracted Text:", extracted_text)  # Debugging
        medical_file = MedicalFile.objects.create(cloudinary_url=cloudinary_url, **validated_data)
        return medical_file
