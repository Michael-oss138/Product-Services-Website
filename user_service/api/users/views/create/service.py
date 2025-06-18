from result import Result, Ok
from django.db import transaction
from datetime import datetime

from codegen.Api.Users import (
    AdminProfile,
    StudentProfile,
    StudentUser,
    TeacherProfile,
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
from codegen.Api.Users.Create.Response.Success import UserCreated
from api.users.models import (
    User as DbUser,
    Student,
    Teacher,
    Admin,
    Guardian,
)
from .types import Request, Response


def service(
    payload: Request.Body,
) -> Result[Response.Success, Response.Error]:
    with transaction.atomic():
        user = DbUser.objects.create(
            first_name=payload.root.first_name,
            last_name=payload.root.last_name,
            middle_name=payload.root.middle_name,
            phone=payload.root.phone,
            email=payload.root.email,
            user_type=payload.root.type,
        )

        match payload.root.type:
            case "STUDENT":
                assert isinstance(payload.root, StudentCreate), (
                    "Invalid payload type for student"
                )

                profile = Student.objects.create(
                    user=user,
                    date_of_birth=datetime.strptime(
                        payload.root.profile.date_of_birth, "%Y-%m-%d"
                    ),
                    gender=payload.root.profile.gender,
                    medical_conditions=payload.root.profile.medical_conditions,
                    school_id=payload.root.profile.school_id,
                )

                api_user_profile = StudentUser(
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
                        id=str(profile.id),
                        date_of_birth=profile.date_of_birth.isoformat(),
                        gender="M",
                        medical_conditions=profile.medical_conditions,
                        school_id=str(profile.school_id),
                    ),
                )

            case "TEACHER":
                assert isinstance(payload.root, TeacherCreate), (
                    "Invalid payload type for teacher"
                )

                profile = Teacher.objects.create(
                    user=user,
                    school_id=payload.root.profile.school_id,
                )

                api_user_profile = TeacherUser(
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
                        id=str(profile.id),
                        school_id=str(profile.school_id),
                    ),
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

                api_user_profile = AdminUser(
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
                        id=str(profile.id),
                        role=profile.role,
                        permissions=profile.permissions,
                        school_id=str(profile.school_id) if profile.school_id else None,
                    ),
                )

            case "GUARDIAN":
                assert isinstance(payload.root, GuardianCreate), (
                    "Invalid payload type for guardian"
                )

                profile = Guardian.objects.create(user=user)

                api_user_profile = GuardianUser(
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

        return Ok(
            Response.Success(
                root=UserCreated(code="USER_CREATED", data=api_user_profile)
            )
        )
