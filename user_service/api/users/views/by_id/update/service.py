from result import Result, Ok, Err
from django.db import transaction
from api.users.models import User
from codegen.Api import UserNotFoundError
from codegen.Api.Users.ById.Update.Response.Success import UserUpdated
from .types import Request, Response


def service(id: str, payload: Request.Body) -> Result[Response.Success, Response.Error]:
    with transaction.atomic():
        try:
            User.objects.get(id=id)
        except User.DoesNotExist:
            return Err(
                Response.Error(root=UserNotFoundError(code="ERR_USER_NOT_FOUND"))
            )

        User.objects.filter(id=id).update(**payload.model_dump())

        return Ok(
            Response.Success(
                root=UserUpdated(
                    code="USER_UPDATED",
                )
            )
        )
