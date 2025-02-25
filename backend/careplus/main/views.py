### views.py
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate
from .serializers import RegisterSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import get_user_model

User = get_user_model()

class RegisterView(APIView):
    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        # Check if user already exists
        if 'email' in serializer.errors or 'username' in serializer.errors:
            return Response(serializer.errors, status=status.HTTP_409_CONFLICT)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

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
                return Response({'error': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)

        elif registration_id:
            try:
                user = User.objects.get(registration_id=registration_id)
            except User.DoesNotExist:
                return Response({'error': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)

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