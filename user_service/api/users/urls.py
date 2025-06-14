from django.urls import path
from .views import UserView, UserByIdView

urlpatterns = [
    path("", UserView.as_view(), name="user-list-create"),
    path("<str:id>/", UserByIdView.as_view(), name="user-detail"),
]
