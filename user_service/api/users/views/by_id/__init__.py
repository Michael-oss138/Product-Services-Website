from django.http import JsonResponse
from django.urls import path
from .update.handler import handler as update_handler
from django.views.decorators.csrf import csrf_exempt


@csrf_exempt
def root_handler(request, id: str):
    if request.method == "PATCH":
        return update_handler(request, id)
    else:
        return JsonResponse({"code": "ERR_METHOD_NOT_ALLOWED"}, status=405)


urls = [
    path("<str:id>", root_handler),
]
