from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import MedicalFile
from .cloudinary_helper import upload_file

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


class MedicalFileSerializer(serializers.ModelSerializer):
    class Meta:
        model = MedicalFile
        fields = ['id', 'file', 'cloudinary_url', 'file_type', 'uploaded_at']

    def create(self, validated_data):
        """Upload file to Cloudinary and save URL in the model."""
        file = validated_data.pop("file")  # Get file object
        cloudinary_url = upload_file(file)  # Upload and get Cloudinary URL
        medical_file = MedicalFile.objects.create(cloudinary_url=cloudinary_url, **validated_data)
        return medical_file
