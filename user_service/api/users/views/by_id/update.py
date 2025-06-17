from django.http import JsonResponse
from django.db import transaction
from django.urls import path
from codegen.Api.Users.ById.Update.Response.Success import Success as UpdateSuccess


@transaction.atomic
def view(request, id: str):
    """Update a user by ID"""
    try:
        # TODO: Fetch existing user
        # TODO: Parse update data based on user type
        # TODO: Update user in database

        response = {
            "code": "USER_UPDATED",
            "data": {},  # Replace with updated user
        }

        return JsonResponse(response, status=200)

    except Exception as e:
        return JsonResponse({"code": "ERR_UNEXPECTED", "message": str(e)}, status=500)


url = path("<str:id>/update/", view, name="user-update")
