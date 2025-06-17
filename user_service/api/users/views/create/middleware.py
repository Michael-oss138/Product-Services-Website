from django.http import HttpRequest
from api.users.utils import validate_json_bytestring
from codegen.Api.Users.Create.Request import Body


def middleware(request: HttpRequest):
    validated_payload = validate_json_bytestring(request.body, Body)
    print(validated_payload)
