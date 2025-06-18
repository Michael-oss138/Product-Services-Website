from django.db import models
from django.utils import timezone
import uuid


class User(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    middle_name = models.CharField(max_length=255, null=True, blank=True)
    phone = models.CharField(max_length=20, null=True, blank=True)
    email = models.EmailField(null=True, blank=True)
    user_type = models.CharField(
        max_length=20,
        choices=[
            ("TEACHER", "Teacher"),
            ("GUARDIAN", "Guardian"),
            ("ADMIN", "Admin"),
            ("SUPER_ADMIN", "Super Admin"),
            ("STUDENT", "Student"),
        ],
    )
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "users"


class Student(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(
        User, on_delete=models.CASCADE, related_name="student_profile"
    )
    school_id = models.UUIDField()
    date_of_birth = models.DateField()
    gender = models.CharField(
        max_length=1,
        choices=[
            ("M", "Male"),
            ("F", "Female"),
        ],
    )
    medical_conditions = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "students"


class Teacher(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(
        User, on_delete=models.CASCADE, related_name="teacher_profile"
    )
    school_id = models.UUIDField()
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "teachers"


class Admin(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(
        User, on_delete=models.CASCADE, related_name="admin_profile"
    )
    role = models.CharField(
        max_length=20,
        choices=[
            ("SUPER_ADMIN", "Super Admin"),
            ("ACADEMIC_ADMIN", "Academic Admin"),
            ("FINANCIAL_ADMIN", "Financial Admin"),
        ],
    )
    permissions = models.TextField()
    school_id = models.UUIDField(null=True, blank=True)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "admins"


class Guardian(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.OneToOneField(
        User, on_delete=models.CASCADE, related_name="guardian_profile"
    )
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "guardians"


class GuardianStudent(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    student = models.ForeignKey(
        Student, on_delete=models.CASCADE, related_name="guardian_relationships"
    )
    guardian = models.ForeignKey(
        Guardian, on_delete=models.CASCADE, related_name="student_relationships"
    )
    relationship_type = models.CharField(max_length=50)
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "guardian_students"
        unique_together = ("student", "guardian")
