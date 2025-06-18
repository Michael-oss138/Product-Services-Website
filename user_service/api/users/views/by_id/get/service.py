from result import Result, Ok, Err
from api.users.models import User, Student, Teacher, Admin, Guardian
from .types import Response
from codegen.Api.Users import (
    StudentUser,
    TeacherUser,
    AdminUser,
    GuardianUser,
    StudentProfile,
    TeacherProfile,
    AdminProfile,
)
from codegen.Api import UserNotFoundError


def service(id: str) -> Result[Response.Success, Response.Error]:
    try:
        user = User.objects.get(id=id)
    except User.DoesNotExist:
        return Err(Response.Error(root=UserNotFoundError(code="ERR_USER_NOT_FOUND")))

    match user.user_type:
        case "STUDENT":
            student = Student.objects.get(user=user)
            api_user = StudentUser(
                id=str(user.id),
                first_name=user.first_name,
                last_name=user.last_name,
                middle_name=user.middle_name,
                phone=user.phone,
                email=user.email,
                user_type="STUDENT",
                created_at=user.created_at.isoformat(),
                updated_at=user.updated_at.isoformat(),
                type="STUDENT",
                profile=StudentProfile(
                    id=str(student.id),
                    date_of_birth=student.date_of_birth.isoformat(),
                    gender=student.gender if student.gender in ("M", "F") else "M",
                    medical_conditions=student.medical_conditions,
                    school_id=str(student.school_id),
                ),
            )
        case "TEACHER":
            teacher = Teacher.objects.get(user=user)
            api_user = TeacherUser(
                id=str(user.id),
                first_name=user.first_name,
                last_name=user.last_name,
                middle_name=user.middle_name,
                phone=user.phone,
                email=user.email,
                user_type="TEACHER",
                created_at=user.created_at.isoformat(),
                updated_at=user.updated_at.isoformat(),
                type="TEACHER",
                profile=TeacherProfile(
                    id=str(teacher.id),
                    school_id=str(teacher.school_id),
                ),
            )
        case "ADMIN":
            admin = Admin.objects.get(user=user)
            api_user = AdminUser(
                id=str(user.id),
                first_name=user.first_name,
                last_name=user.last_name,
                middle_name=user.middle_name,
                phone=user.phone,
                email=user.email,
                user_type="ADMIN",
                created_at=user.created_at.isoformat(),
                updated_at=user.updated_at.isoformat(),
                type="ADMIN",
                profile=AdminProfile(
                    id=str(admin.id),
                    role=admin.role,  # type: ignore
                    permissions=admin.permissions,
                    school_id=str(admin.school_id) if admin.school_id else None,
                ),
            )
        case "GUARDIAN":
            guardian = Guardian.objects.get(user=user)
            api_user = GuardianUser(
                id=str(user.id),
                first_name=user.first_name,
                last_name=user.last_name,
                middle_name=user.middle_name,
                phone=user.phone,
                email=user.email,
                user_type="GUARDIAN",
                created_at=user.created_at.isoformat(),
                updated_at=user.updated_at.isoformat(),
                type="GUARDIAN",
            )

    return Ok(Response.Success(code="USER_FOUND", data=api_user))
