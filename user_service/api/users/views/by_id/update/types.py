from codegen.Api.Users.ById.Update.Request import Path, Body
from codegen.Api.Users.ById.Update.Response.Success import Success
from codegen.Api.Users.ById.Update.Response.Error import Error


class Request:
    Path = Path
    Body = Body


class Response:
    Success = Success
    Error = Error


class ResponseRoot:
    Success = Success
    Error = Error
