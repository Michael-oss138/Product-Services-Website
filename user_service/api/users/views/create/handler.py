from django.http import HttpRequest, JsonResponse
from django.db import transaction
from django.urls import path
from django.views.decorators.http import require_POST
from django.views.decorators.csrf import csrf_exempt
from .service import service
from .middleware import middleware
from result import is_err
from .types import Response


@require_POST
@csrf_exempt
@transaction.atomic
def handler(request: HttpRequest):
    response: Response.Success | Response.Error
    status_code: int

    payload = middleware(request)

    result = service(payload)

    response = result.value

    if is_err(result):
        match result.value.root.code:
            case "ERR_EMAIL_ALREADY_EXISTS":
                status_code = 409
            case "ERR_PHONE_ALREADY_EXISTS":
                status_code = 409
            case "ERR_STUDENT_ID_ALREADY_EXISTS":
                status_code = 409
            case _:
                status_code = 500
    else:
        status_code = 201

    return JsonResponse(response.model_dump(mode="json"), status=status_code)
