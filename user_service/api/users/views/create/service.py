from result import Result
from .types import Request, Response


def service(
    payload: Request.Body,
) -> Result[Response.Success, Response.Error]:
    pass
