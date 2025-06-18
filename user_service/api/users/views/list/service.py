from result import Result, Ok
from django.core.paginator import Paginator
from api.users.models import User, Student, Teacher, Admin, Guardian
from codegen.Api import Pagination
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


def service(query: Request.Query) -> Result[Response.Success, Response.Error]:
    page = query.page or 1
    per_page = query.per_page or 10
    user_type = query.type

    users_qs = User.objects.all().order_by("-created_at")
    if user_type:
        users_qs = users_qs.filter(user_type=user_type)

    paginator = Paginator(users_qs, per_page)
    page_obj = paginator.get_page(page)

    api_users = []
    for user in page_obj.object_list:
        match user.user_type:
            case "STUDENT":
                student = Student.objects.get(user=user)
                gender = student.gender if student.gender in ("M", "F") else "M"
                api_users.append(
                    StudentUser(
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
                            gender=gender,
                            medical_conditions=student.medical_conditions,
                            school_id=str(student.school_id),
                        ),
                    )
                )
            case "TEACHER":
                teacher = Teacher.objects.get(user=user)
                api_users.append(
                    TeacherUser(
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
                )
            case "ADMIN":
                admin = Admin.objects.get(user=user)
                api_users.append(
                    AdminUser(
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
                )
            case "GUARDIAN":
                guardian = Guardian.objects.get(user=user)
                api_users.append(
                    GuardianUser(
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
                )

    return Ok(
        Response.Success(
            code="LIST",
            data=api_users,
            meta=Pagination.Meta(
                page=page_obj.number,
                per_page=per_page,
                total=paginator.count,
            ),
        )
    )
