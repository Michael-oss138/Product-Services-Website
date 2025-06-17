from django.http import JsonResponse
from django.db import transaction
from django.urls import path
from codegen.Api.Users.Create.Request import Body
# from codegen.Api.Users.Create.Response.Success import Success as CreateSuccess
# from codegen.Api.Users.Create.Response.Error import Error as CreateError


@transaction.atomic
def view(request):
    """Create a new user"""
    try:
        # TODO: Parse request body based on user type
        # TODO: Validate input data
        # TODO: Create user in database

        # Create success response
        response = {
            "code": "USER_CREATED",
            "data": {},  # Replace with actual created user
        }

        return JsonResponse(response, status=201)

    except Exception as e:
        return JsonResponse({"code": "ERR_UNEXPECTED", "message": str(e)}, status=500)


url = path("create/", view, name="user-create")
