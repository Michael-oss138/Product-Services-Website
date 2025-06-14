from django.shortcuts import render
from typing import List, Optional
from django.http import JsonResponse
from django.views import View
from django.core.paginator import Paginator
from django.db import transaction
from django.utils import timezone
from codegen.Api.Users import (
    User,
    StudentUser,
    TeacherUser,
    AdminUser,
    GuardianUser,
    StudentCreate,
    TeacherCreate,
    AdminCreate,
    GuardianCreate,
    StudentUpdate,
    TeacherUpdate,
    AdminUpdate,
    GuardianUpdate,
)
from codegen.Api.Pagination import Paginated, Meta, Options
from codegen.Api.Users.Create.Response.Success import Success as CreateSuccess
from codegen.Api.Users.Create.Response.Error import Error as CreateError
from codegen.Api.Users.List.Response.Success import Success as ListSuccess
from codegen.Api.Users.ById.Get.Response.Success import Success as GetSuccess
from codegen.Api.Users.ById.Update.Response.Success import Success as UpdateSuccess
from codegen.Api.Users.ById.Delete.Response.Success import Success as DeleteSuccess

# Create your views here.


class UserView(View):
    def get(self, request):
        """List users with optional filtering by type"""
        try:
            # Get query parameters
            page = int(request.GET.get("page", 1))
            per_page = int(request.GET.get("per_page", 10))
            user_type = request.GET.get("type")

            # TODO: Implement actual database query with filters
            users = []  # Replace with actual database query

            # Paginate results
            paginator = Paginator(users, per_page)
            page_obj = paginator.get_page(page)

            # Create response
            response = ListSuccess(
                code="LIST",
                data=page_obj.object_list,
                meta=Meta(page=page, per_page=per_page, total=paginator.count),
            )

            return JsonResponse(response.model_dump(), status=200)

        except Exception as e:
            return JsonResponse(
                {"code": "ERR_UNEXPECTED", "message": str(e)}, status=500
            )

    @transaction.atomic
    def post(self, request):
        """Create a new user"""
        try:
            # TODO: Parse request body based on user type
            # TODO: Validate input data
            # TODO: Create user in database

            # Create success response
            response = CreateSuccess(
                code="USER_CREATED",
                data=User(),  # Replace with actual created user
            )

            return JsonResponse(response.model_dump(), status=201)

        except Exception as e:
            return JsonResponse(
                {"code": "ERR_UNEXPECTED", "message": str(e)}, status=500
            )


class UserByIdView(View):
    def get(self, request, id: str):
        """Get a user by ID"""
        try:
            # TODO: Fetch user from database
            user = None  # Replace with actual database query

            if not user:
                return JsonResponse({"code": "ERR_USER_NOT_FOUND"}, status=404)

            response = GetSuccess(code="USER_FOUND", data=user)

            return JsonResponse(response.model_dump(), status=200)

        except Exception as e:
            return JsonResponse(
                {"code": "ERR_UNEXPECTED", "message": str(e)}, status=500
            )

    @transaction.atomic
    def patch(self, request, id: str):
        """Update a user by ID"""
        try:
            # TODO: Fetch existing user
            # TODO: Parse update data based on user type
            # TODO: Update user in database

            response = UpdateSuccess(
                code="USER_UPDATED",
                data=User(),  # Replace with updated user
            )

            return JsonResponse(response.model_dump(), status=200)

        except Exception as e:
            return JsonResponse(
                {"code": "ERR_UNEXPECTED", "message": str(e)}, status=500
            )

    @transaction.atomic
    def delete(self, request, id: str):
        """Delete a user by ID"""
        try:
            # TODO: Delete user from database

            response = DeleteSuccess(code="USER_DELETED")

            return JsonResponse(response.model_dump(), status=200)

        except Exception as e:
            return JsonResponse(
                {"code": "ERR_UNEXPECTED", "message": str(e)}, status=500
            )
