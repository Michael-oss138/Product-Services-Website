from django.urls import path, include
from .views import urls

urlpatterns = [
    path("", include(urls)),
]
