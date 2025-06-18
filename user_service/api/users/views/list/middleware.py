from django.http import HttpRequest

from api.users.utils import validate
from .types import Request


def middleware(request: HttpRequest):
    return validate(request.GET.dict(), Request.Query)
