from django.http import JsonResponse
from django.urls import path
from .list.handler import handler as list_handler
from .create.handler import handler as create_handler
from django.views.decorators.csrf import csrf_exempt


@csrf_exempt
def root_handler(request):
    if request.method == "GET":
        return list_handler(request)
    elif request.method == "POST":
        return create_handler(request)
    else:
        return JsonResponse({"code": "ERR_METHOD_NOT_ALLOWED"}, status=405)


urls = [
    path("", root_handler),
]
