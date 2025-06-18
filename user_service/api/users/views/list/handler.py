from django.http import HttpRequest, JsonResponse
from django.views.decorators.http import require_GET
from .service import service
from .types import Response
from .middleware import middleware
from result import is_err


@require_GET
def handler(request: HttpRequest):
    status_code: int
    response: Response.Success | Response.Error

    payload = middleware(request)

    result = service(payload)

    response = result.value

    if is_err(result):
        status_code = 500
    else:
        status_code = 200

    return JsonResponse(response.model_dump(mode="json"), status=status_code)
