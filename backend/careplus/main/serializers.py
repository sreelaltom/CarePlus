from rest_framework import serializers
from django.contrib.auth import get_user_model

User = get_user_model()

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'is_patient', 'is_doctor', 'registration_id', 'phone_number']

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            is_patient=validated_data.get('is_patient', False),
            is_doctor=validated_data.get('is_doctor', False),
            registration_id=validated_data.get('registration_id', None),
            phone_number=validated_data.get('phone_number', None),
        )
        return user
