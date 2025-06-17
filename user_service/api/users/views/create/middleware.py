from django.http import HttpRequest
from api.users.utils import validate_json_bytestring
from codegen.Api.Users.Create.Request import Body


def middleware(request: HttpRequest):
    return validate_json_bytestring(request.body, Body)
