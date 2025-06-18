from codegen.Api.Users.Create.Request import Body
from codegen.Api.Users.Create.Response.Success import Success as ApiSuccess
from codegen.Api.Users.Create.Response.Error import Error as ApiError


class Request:
    Body = Body


class Response:
    Success = ApiSuccess
    Error = ApiError
