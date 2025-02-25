### serializers.py
from rest_framework import serializers
from django.contrib.auth import get_user_model

User = get_user_model()

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    email = serializers.EmailField(allow_null=True, required=False)  # Allow null email for doctors

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'is_patient', 'is_doctor', 'registration_id', 'phone_number']

    def create(self, validated_data):
        if User.objects.filter(username=validated_data['username']).exists():
            raise serializers.ValidationError({"error": "A user with that username already exists."})
        if validated_data.get('email') and User.objects.filter(email=validated_data['email']).exists():
            raise serializers.ValidationError({"error": "A user with that email already exists."})
        
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