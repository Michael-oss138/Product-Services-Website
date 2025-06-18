from django.http import JsonResponse
from pydantic import BaseModel, ValidationError as PydanticValidationError
from typing import TypeVar, Type

from pydantic_core import ErrorDetails

from codegen.Api import BadRequestError, ValidationErrorDetail


T = TypeVar("T", bound=BaseModel)


class ValidationError(Exception):
    response: JsonResponse

    def __init__(self, errors: list[ErrorDetails]):
        x = errors[0]["loc"]
        super().__init__()
        self.response = JsonResponse(
            BadRequestError(
                code="ERR_EXPECTED_DATA_NOT_RECEIVED",
                errors=[
                    ValidationErrorDetail(
                        type=error["type"],
                        loc=list(map(str, error["loc"])),
                        msg=error["msg"],
                    )
                    for error in errors
                ],
            ).model_dump(mode="json"),
            status=400,
        )


def validate_json(raw_payload: bytes, model: Type[T]) -> T:
    try:
        return model.model_validate_json(raw_payload)
    except PydanticValidationError as e:
        raise ValidationError(e.errors())


def validate(obj: dict, model: Type[T]) -> T:
    try:
        return model.model_validate(obj)
    except PydanticValidationError as e:
        raise ValidationError(e.errors())
