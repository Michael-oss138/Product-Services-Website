from django.http import JsonResponse, HttpRequest
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from result import is_err
from .service import service
from .types import Response
from .middleware import middleware


@csrf_exempt
@require_http_methods(["PATCH"])
def handler(request: HttpRequest, id: str):
    status_code: int
    response: Response.Success | Response.Error

    payload = middleware(request)

    result = service(id, payload)

    response = result.value

    if is_err(result):
        match result.value.root.code:
            case "ERR_USER_NOT_FOUND":
                status_code = 404
            case _:
                status_code = 500
    else:
        status_code = 200

    return JsonResponse(response.model_dump(mode="json"), status=status_code)
