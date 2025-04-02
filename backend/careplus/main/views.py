import os
import numpy as np
from PIL import Image
from django.conf import settings
from django.core.files.storage import default_storage
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from django.views import View
from rest_framework import generics, permissions, status
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import cloudinary.uploader
from cloudinary.uploader import upload
from django.contrib.auth import get_user_model
from django.http import JsonResponse
from django.views import View
from django.shortcuts import get_object_or_404
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from .models import CancerPrediction

from .models import MedicalFile, MedicalReport, Investigation, CancerPrediction
from .serializers import MedicalFileSerializer, RegisterSerializer, CancerPredictionSerializer
from .cloudinary_helper import delete_file



User = get_user_model()

class RegisterView(APIView):
    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        # Custom error response for username and email
        if 'error' in serializer.errors:
            return Response(serializer.errors, status=status.HTTP_409_CONFLICT)

        return Response(serializer.errors, status=status.HTTP_409_CONFLICT)


class LoginView(APIView):
    def post(self, request):
        email = request.data.get('email')
        registration_id = request.data.get('registration_id')
        password = request.data.get('password')

        user = None
        if email:
            try:
                user = User.objects.get(email=email)
            except User.DoesNotExist:
                return Response({'error': 'Invalid credentials'}, status=status.HTTP_404_NOT_FOUND)

        elif registration_id:
            try:
                user = User.objects.get(registration_id=registration_id)
            except User.DoesNotExist:
                return Response({'error': 'Invalid credentials'}, status=status.HTTP_404_NOT_FOUND)

        if user and user.check_password(password):
            refresh = RefreshToken.for_user(user)
            return Response({
                'uid': user.id,
                'email': user.email,
                'is_patient': user.is_patient,
                'is_doctor': user.is_doctor,
                'registration_id': user.registration_id,
                'phone_number': user.phone_number,
                'refresh': str(refresh),
                'access': str(refresh.access_token),
                'message': 'Login successful!'
            }, status=status.HTTP_200_OK)

        return Response({'error': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)

class TokenRefreshView(APIView):
    def post(self, request):
        refresh_token = request.data.get("refresh")
        if not refresh_token:
            return Response({"error": "Refresh token is required"}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            refresh = RefreshToken(refresh_token)
            return Response({
                "access": str(refresh.access_token)
            }, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": "Invalid refresh token"}, status=status.HTTP_400_BAD_REQUEST)
        

class UploadMedicalFileView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        """Upload a medical file for the authenticated user."""
        serializer = MedicalFileSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class GetMedicalFilesView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        """Fetch all medical files uploaded by the authenticated user."""
        medical_files = MedicalFile.objects.filter(user=request.user)
        serializer = MedicalFileSerializer(medical_files, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class DeleteMedicalFileView(APIView):
    permission_classes = [IsAuthenticated]

    def delete(self, request, file_id):
        """Delete a medical file and its related data if it belongs to the authenticated user."""
        try:
            medical_file = MedicalFile.objects.get(id=file_id, user=request.user)
            
            # Delete associated medical reports and investigations
            MedicalReport.objects.filter(medical_file=medical_file).delete()
            Investigation.objects.filter(medical_file=medical_file).delete()

            # Delete file from Cloudinary
            delete_file(medical_file.cloudinary_url)
            
            # Delete the medical file entry from DB
            medical_file.delete()

            return Response({"message": "File and associated data deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
        except MedicalFile.DoesNotExist:
            return Response({"error": "File not found or unauthorized."}, status=status.HTTP_404_NOT_FOUND)
class UserMedicalFilesView(generics.ListAPIView):
    """API to fetch all medical files uploaded by the logged-in user."""
    serializer_class = MedicalFileSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        """Return medical files only belonging to the logged-in user."""
        return MedicalFile.objects.filter(user=self.request.user)

    def list(self, request, *args, **kwargs):
        """Customize response to return only extracted structured text."""
        queryset = self.get_queryset()
        data = [
            {
                "file_id": file.id,
                "file_name": file.file.name,
                "uploaded_at": file.uploaded_at,
                "structured_text": file.structured_text
            }
            for file in queryset
        ]
        return Response(data)
class FilterMedicalFilesView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        """Fetch medical files based on query parameters: parameter, from, to."""
        parameter = request.GET.get("parameter")
        from_date = request.GET.get("from")
        to_date = request.GET.get("to")

        if not from_date or not to_date:
            return Response({"error": "Both 'from' and 'to' dates are required."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            filtered_files = MedicalFile.objects.filter(
                user=request.user,
                uploaded_at__date__gte=from_date,
                uploaded_at__date__lte=to_date
            )

            if parameter:
                filtered_files = filtered_files.filter(structured_text__icontains=parameter)

            # Transform data to required format
            response_data = []
            for file in filtered_files:
                uploaded_date = file.uploaded_at.date().isoformat()  # Extract date only
                for test in file.structured_text.get("investigations", []):
                    response_data.append({
                        "value": test["observed_value"],
                        "date": uploaded_date,
                        "test_name": test["test_name"],
                    })
            k= []
            for respon in response_data:
                if respon["test_name"]==parameter:
                    k.append(respon)
            return Response(k, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
class DropDown(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        """Fetch all unique test names from the user's medical files."""
        try:
            # Get all medical files for the user
            medical_files = MedicalFile.objects.filter(user=request.user)

            # Extract unique test names
            unique_test_names = set()
            for file in medical_files:
                structured_text = file.structured_text or {}  # Ensure it's a dictionary
                investigations = structured_text.get("investigations", [])

                for test in investigations:
                    if isinstance(test, dict) and "test_name" in test:
                        unique_test_names.add(test["test_name"])

            return Response(list(unique_test_names), status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

BASE_DIR = os.path.dirname(os.path.abspath(__file__)) 
MODEL_PATH = os.path.join(BASE_DIR, "model.h5")
print(MODEL_PATH)
model = load_model(MODEL_PATH)
def predict_cancer(img_path):
    """Predicts cancer from a given image path using the loaded model."""
    try:
        img = image.load_img(img_path, target_size=(224, 224))
        img_array = image.img_to_array(img) / 255.0
        img_array = np.expand_dims(img_array, axis=0)

        prediction_probs = model.predict(img_array)
        confidence_score = float(prediction_probs[0][0])

        prediction_label = "Normal" if confidence_score > 0.5 else "Adenocarcinoma Cancer"

        return {"prediction": prediction_label, "confidence": round(confidence_score, 4)}

    except Exception as e:
        return {"error": str(e)}

class CancerPredictionView(APIView):
    """API for predicting chest cancer from medical images."""
    permission_classes = [IsAuthenticated]

    def post(self, request):
        file = request.FILES.get("file")
        if not file:
            return Response({"error": "No file uploaded"}, status=status.HTTP_400_BAD_REQUEST)

        print(f"Received file: {file.name}, Size: {file.size}")

        # Save the image temporarily
        file_path = default_storage.save(f"uploads/{file.name}", file)
        full_file_path = os.path.join(settings.MEDIA_ROOT, file_path)

        # Predict cancer
        result = predict_cancer(full_file_path)

        if "error" in result:
            return Response(result, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # Reset file pointer before uploading
        file.seek(0)

        # Upload to Cloudinary with user metadata
        try:
            cloudinary_response = cloudinary.uploader.upload(
                file, folder="chest_cancer_predictions", public_id=request.user.email
            )
        except cloudinary.exceptions.Error as e:
            return Response({"error": f"Cloudinary upload failed: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # Save the prediction in DB
        prediction = CancerPrediction.objects.create(
            user=request.user,
            image_url=cloudinary_response["secure_url"],
            prediction=result["prediction"]
        )

        return Response({
            "id": prediction.id,
            "user": request.user.email,
            "image_url": prediction.image_url,
            "prediction": result["prediction"],
            "uploaded_at": prediction.uploaded_at
        }, status=status.HTTP_200_OK)

class UserPredictionsView(APIView):
    """API to retrieve all cancer predictions made by the authenticated user."""
    permission_classes = [IsAuthenticated]

    def get(self, request):
        predictions = CancerPrediction.objects.filter(user=request.user)
        serializer = CancerPredictionSerializer(predictions, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    



class DeleteCancerImageView(APIView):
    """API to delete a cancer image from Cloudinary and remove the DB record."""
    permission_classes = [IsAuthenticated]

    def delete(self, request, pk, *args, **kwargs):
        # Get the image object
        image = get_object_or_404(CancerPrediction, pk=pk, user=request.user)

        # Extract Cloudinary public ID from the image URL
        try:
            public_id = image.image_url.split("/")[-1].split(".")[0]  # Extract file name without extension
            cloudinary.uploader.destroy(f"chest_cancer_predictions/{public_id}")  # Delete from Cloudinary
        except Exception as e:
            return Response({"error": f"Cloudinary deletion failed: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # Delete the record from DB
        image.delete()
        
        return Response({'message': 'Cancer image deleted successfully'}, status=status.HTTP_200_OK)