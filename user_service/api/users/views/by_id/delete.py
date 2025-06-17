from django.http import JsonResponse
from django.db import transaction
from django.urls import path
from codegen.Api.Users.ById.Delete.Response.Success import Success as DeleteSuccess


@transaction.atomic
def view(request, id: str):
    """Delete a user by ID"""
    try:
        # TODO: Delete user from database

        response = {"code": "USER_DELETED"}

        return JsonResponse(response, status=200)

    except Exception as e:
        return JsonResponse({"code": "ERR_UNEXPECTED", "message": str(e)}, status=500)


url = path("<str:id>/delete/", view, name="user-delete")
