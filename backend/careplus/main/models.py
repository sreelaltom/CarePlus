from django.contrib.auth.models import AbstractUser
from django.db import models
from django.conf import settings
class CustomUser(AbstractUser):
    is_patient = models.BooleanField(default=False)
    is_doctor = models.BooleanField(default=False)
    registration_id = models.CharField(max_length=50, blank=True, null=True, unique=True)  
    phone_number = models.CharField(max_length=15, blank=True, null=True) 



class MedicalFile(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="medical_files")
    file = models.FileField(upload_to="medical_files/", null=True, blank=True)
    cloudinary_url = models.URLField(blank=True, null=True) 
    file_type = models.CharField(max_length=20, choices=[("prescription", "Prescription"), ("lab_result", "Lab Result")])
    uploaded_at = models.DateTimeField(auto_now_add=True)
    structured_text = models.JSONField(null=True, blank=True)

    def __str__(self):
        return f"{self.user.username} - {self.file_type} - {self.uplaoaded_at}"

class MedicalReport(models.Model):
    medical_file = models.ForeignKey(MedicalFile, on_delete=models.CASCADE, related_name="reports")
    report_text = models.TextField()

class Investigation(models.Model):
    medical_file = models.ForeignKey(MedicalFile, on_delete=models.CASCADE, related_name="investigations")
    test_name = models.CharField(max_length=255)
    observed_value = models.CharField(max_length=255)
    units = models.CharField(max_length=50)
    reference_range = models.CharField(max_length=255)


class CancerPrediction(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="cancer_predictions")  
    image_url = models.URLField()
    prediction = models.CharField(max_length=100)
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.email} - {self.prediction}"
class IndianFoodPrediction(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="food_predictions") 
    image_url = models.URLField()
    prediction = models.CharField(max_length=100)
    confidence = models.FloatField()
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.email} - {self.prediction} ({self.confidence})"

