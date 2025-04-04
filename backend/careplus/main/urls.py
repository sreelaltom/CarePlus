from django.urls import path
from .views import RegisterView, LoginView, TokenRefreshView, UploadMedicalFileView, GetMedicalFilesView, DeleteMedicalFileView,UserMedicalFilesView,FilterMedicalFilesView,CancerPredictionView,UserPredictionsView,DeleteCancerImageView,DropDown,IndianFoodPredictionView,DeleteIndianFoodPredictionView,ListIndianFoodPredictionsView
from rest_framework_simplejwt.views import (TokenObtainPairView,)

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
   path('upload/', UploadMedicalFileView.as_view(), name='upload-file'),
    path('files/', GetMedicalFilesView.as_view(), name='get-files'),
    path('files/<int:file_id>/delete/', DeleteMedicalFileView.as_view(), name='delete-file'),
     path('medical-files/', UserMedicalFilesView.as_view(), name='user-medical-files'),
      path('medical-files/filter/', FilterMedicalFilesView.as_view(), name='filter-medical-files'), 
       path("predict-cancer/", CancerPredictionView.as_view(), name="predict-cancer"),
    path("user-predictions/", UserPredictionsView.as_view(), name="user-predictions"),
    path('delete-cancer-image/<int:pk>/', DeleteCancerImageView.as_view(), name='delete-cancer-image'),
    path("dropdown/",DropDown.as_view(),name='dropdown'),
    path("predict/indian-food/", IndianFoodPredictionView.as_view(), name="predict_food"),
    path("predict/indian-food/<int:pk>/delete/", DeleteIndianFoodPredictionView.as_view(), name="delete_prediction"),
     path("predict/indian-food/all/", ListIndianFoodPredictionsView.as_view(), name="list_predictions"),
]
