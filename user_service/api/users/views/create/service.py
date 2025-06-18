from result import Result, Ok, Err
from django.db import transaction

from codegen.Api import (
    CodeModel,
)
from codegen.Api.Users import (
    StudentUser,
    TeacherUser,
    AdminUser,
    GuardianUser,
)
from codegen.Api.Users.Create.Request import (
    StudentCreate,
    TeacherCreate,
    AdminCreate,
    GuardianCreate,
)
from api.users.models import (
    User,
    Student,
    Teacher,
    Admin,
    Guardian,
)
from .types import Request, Response


def service(
    payload: Request.Body,
) -> Result[Response.Success, Response.Error]:
    try:
        with transaction.atomic():
            user = User.objects.create(
                first_name=payload.root.first_name,
                last_name=payload.root.last_name,
                middle_name=payload.root.middle_name,
                phone=payload.root.phone,
                email=payload.root.email,
                user_type=payload.root.type.value,
            )

            match payload.root.type.value:
                case "STUDENT":
                    assert isinstance(payload.root, StudentCreate), (
                        "Invalid payload type for student"
                    )

                    profile = Student.objects.create(
                        user=user,
                        date_of_birth=payload.root.profile.date_of_birth,
                        gender=payload.root.profile.gender,
                        medical_conditions=payload.root.profile.medical_conditions,
                        school_id=payload.root.profile.school_id,
                    )

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
                        profile={
                            "id": str(profile.id),
                            "date_of_birth": profile.date_of_birth.isoformat(),
                            "gender": profile.gender,
                            "medical_conditions": profile.medical_conditions,
                            "school_id": str(profile.school_id),
                        },
                    )

                case "TEACHER":
                    assert isinstance(payload.root, TeacherCreate), (
                        "Invalid payload type for teacher"
                    )

                    profile = Teacher.objects.create(
                        user=user,
                        school_id=payload.root.profile.school_id,
                    )

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
                        profile={
                            "school_id": str(profile.school_id),
                        },
                    )

                case "ADMIN":
                    assert isinstance(payload.root, AdminCreate), (
                        "Invalid payload type for admin"
                    )

                    profile = Admin.objects.create(
                        user=user,
                        role=payload.root.profile.role,
                        permissions=payload.root.profile.permissions,
                        school_id=payload.root.profile.school_id,
                    )

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
                        profile={
                            "role": profile.role,
                            "permissions": profile.permissions,
                            "school_id": str(profile.school_id)
                            if profile.school_id
                            else None,
                        },
                    )

                case "GUARDIAN":
                    assert isinstance(payload.root, GuardianCreate), (
                        "Invalid payload type for guardian"
                    )

                    profile = Guardian.objects.create(user=user)

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

            return Ok(Response.Success(code="USER_CREATED", data=api_user))

    except Exception as e:
        return Err(Response.Error(code=CodeModel.ERR_UNEXPECTED))
