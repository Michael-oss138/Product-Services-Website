from django.http import HttpRequest
from api.users.utils import ValidationError


class ExceptionHandlingMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request: HttpRequest):
        response = self.get_response(request)
        return response

    def process_exception(self, request: HttpRequest, exception: Exception):
        if isinstance(exception, ValidationError):
            return exception.response

        return None
