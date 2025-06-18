from django.http import JsonResponse
from django.core.paginator import Paginator
from django.urls import path
# from codegen.Api.Users.List.Response.Success import Success as ListSuccess


def view(request):
    """List users with optional filtering by type"""
    try:
        # Get query parameters
        page = int(request.GET.get("page", 1))
        per_page = int(request.GET.get("per_page", 10))
        # user_type = request.GET.get("type")

        # TODO: Implement actual database query with filters
        users = []  # Replace with actual database query

        # Paginate results
        paginator = Paginator(users, per_page)
        page_obj = paginator.get_page(page)

        # Create response
        response = {
            "code": "LIST",
            "data": page_obj.object_list,
            "meta": {"page": page, "per_page": per_page, "total": paginator.count},
        }

        return JsonResponse(response, status=200)

    except Exception as e:
        return JsonResponse({"code": "ERR_UNEXPECTED", "message": str(e)}, status=500)


url = path("", view, name="user-list")
