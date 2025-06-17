from django.http import HttpRequest, JsonResponse
from django.db import transaction
from django.urls import path
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from codegen.Api.Users.Create.Request import Body
from .middleware import validate

# from codegen.Api.Users.Create.Response.Success import Success as CreateSuccess
# from codegen.Api.Users.Create.Response.Error import Error as CreateError


@require_http_methods(["POST"])
@csrf_exempt
@transaction.atomic
def view(request: HttpRequest):
    try:
        validate(request)
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
        return JsonResponse({"code": "ERR_UNEXPECTED"}, status=500)


url = path("", view)
