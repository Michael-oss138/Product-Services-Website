from result import Result, Ok

from codegen.Api import CodeModel, UnexpectedError
from .types import Request, Response


def service(
    payload: Request.Body,
) -> Result[Response.Success, Response.Error]:
    return Ok(Response.Error(root=UnexpectedError(code=CodeModel.ERR_UNEXPECTED)))
