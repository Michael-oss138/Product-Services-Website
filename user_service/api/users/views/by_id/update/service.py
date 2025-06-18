from result import Result, Ok, Err
from django.db import transaction
from api.users.models import User, Student, Teacher, Admin, Guardian
from codegen.Api import UserNotFoundError
from codegen.Api.Users.ById.Update.Response.Success import UserUpdated
from .types import Request, Response
from codegen.Api.Users import (
    StudentUser,
    TeacherUser,
    AdminUser,
    GuardianUser,
    StudentProfile,
    TeacherProfile,
    AdminProfile,
)


def service(id: str, payload: Request.Body) -> Result[Response.Success, Response.Error]:
    with transaction.atomic():
        user = User.objects.get(id=id)

        if not user:
            return Err(
                Response.Error(root=UserNotFoundError(code="ERR_USER_NOT_FOUND"))
            )

        profile: Student | Teacher | Admin | Guardian

        match payload.root.type:
            case "STUDENT":
                profile = Student.objects.get(user=user)
            case "TEACHER":
                profile = Teacher.objects.get(user=user)
            case "ADMIN":
                profile = Admin.objects.get(user=user)
            case "GUARDIAN":
                profile = Guardian.objects.get(user=user)

        # TODO: Fetch user by id, update fields, handle user type logic
        # For now, just return a placeholder response
        return Ok(
            Response.Success(
                root=UserUpdated(
                    code="USER_UPDATED",
                )
            )
        )
