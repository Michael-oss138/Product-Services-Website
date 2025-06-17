from django.http import JsonResponse
from django.urls import path
from codegen.Api.Users.ById.Get.Response.Success import Success as GetSuccess


def view(request, id: str):
    """Get a user by ID"""
    try:
        # TODO: Fetch user from database
        user = None  # Replace with actual database query

        if not user:
            return JsonResponse({"code": "ERR_USER_NOT_FOUND"}, status=404)

        response = {"code": "USER_FOUND", "data": user}

        return JsonResponse(response, status=200)

    except Exception as e:
        return JsonResponse({"code": "ERR_UNEXPECTED", "message": str(e)}, status=500)


url = path("<str:id>/", view, name="user-get")
