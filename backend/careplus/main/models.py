from django.contrib.auth.models import AbstractUser
from django.db import models
from django.conf import settings
class CustomUser(AbstractUser):
    is_patient = models.BooleanField(default=False)
    is_doctor = models.BooleanField(default=False)
    registration_id = models.CharField(max_length=50, blank=True, null=True, unique=True)  # Unique for doctors
    phone_number = models.CharField(max_length=15, blank=True, null=True)  # For doctors



class MedicalFile(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="medical_files")
    file = models.FileField(upload_to="medical_files/", null=True, blank=True)
    cloudinary_url = models.URLField(blank=True, null=True)  # Store Cloudinary URL
    file_type = models.CharField(max_length=20, choices=[("prescription", "Prescription"), ("lab_result", "Lab Result")])
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.file_type} - {self.uploaded_at}"

