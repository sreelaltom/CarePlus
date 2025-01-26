from django.contrib import admin  # Add this import
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('main.urls')),  # You should not include a '/' in the path here
]
