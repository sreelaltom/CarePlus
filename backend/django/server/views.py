from rest_framework.decorators import api_view
from rest_framework.response import Response
from . serializers import UserSerializer
from django.contrib.auth.models import User
from rest_framework import status
from rest_framework.authtoken.models import Token


@api_view(['POST'])
def login(request):
    return Response({})