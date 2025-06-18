from codegen.Api.Users.List.Request import Query
from codegen.Api.Users.List.Response.Success import Success
from codegen.Api.Users.List.Response.Error import Error


class Request:
    Query = Query


class Response:
    Success = Success
    Error = Error


class ResponseRoot:
    Success = Success
    Error = Error
