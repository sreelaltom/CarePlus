from django.urls import path
from .views import RegisterView, LoginView, TokenRefreshView, UploadMedicalFileView, GetMedicalFilesView, DeleteMedicalFileView
from rest_framework_simplejwt.views import (TokenObtainPairView,)

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
   path('upload/', UploadMedicalFileView.as_view(), name='upload-file'),
    path('files/', GetMedicalFilesView.as_view(), name='get-files'),
    path('files/<int:file_id>/delete/', DeleteMedicalFileView.as_view(), name='delete-file'),
]
