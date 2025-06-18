from django.http import HttpRequest
from api.users.utils import validate_json
from codegen.Api.Users.Create.Request import Body


def middleware(request: HttpRequest):
    return validate_json(request.body, Body)
