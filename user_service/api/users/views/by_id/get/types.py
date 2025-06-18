from codegen.Api.Users.ById.Get.Request import Path
from codegen.Api.Users.ById.Get.Response.Success import Success
from codegen.Api.Users.ById.Get.Response.Error import Error


class Request:
    Path = Path


class Response:
    Success = Success
    Error = Error


class ResponseRoot:
    Success = Success
    Error = Error
