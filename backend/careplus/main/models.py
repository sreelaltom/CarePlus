from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    is_patient = models.BooleanField(default=False)
    is_doctor = models.BooleanField(default=False)
    registration_id = models.CharField(max_length=50, blank=True, null=True)  # For doctors
    phone_number = models.CharField(max_length=15, blank=True, null=True)    # For doctors
