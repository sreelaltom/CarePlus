from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from .models import MedicalFile
from .serializers import MedicalFileSerializer, RegisterSerializer
from .cloudinary_helper import delete_file
from django.contrib.auth import authenticate, get_user_model
from rest_framework_simplejwt.tokens import RefreshToken

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
        """Delete a medical file if it belongs to the authenticated user."""
        try:
            medical_file = MedicalFile.objects.get(id=file_id, user=request.user)
            delete_file(medical_file.cloudinary_url)  # Delete from Cloudinary
            medical_file.delete()  # Delete from DB
            return Response({"message": "File deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
        except MedicalFile.DoesNotExist:
            return Response({"error": "File not found or unauthorized."}, status=status.HTTP_404_NOT_FOUND)