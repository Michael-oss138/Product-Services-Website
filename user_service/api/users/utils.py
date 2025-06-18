from django.http import JsonResponse
from pydantic import BaseModel, ValidationError as PydanticValidationError
from typing import TypeVar, Type

from pydantic_core import ErrorDetails

from codegen.Api import BadRequestError, Code


T = TypeVar("T", bound=BaseModel)


class ValidationError(Exception):
    response: JsonResponse

    def __init__(self, errors: list[ErrorDetails]):
        super().__init__()
        self.response = JsonResponse(
            BadRequestError(code=Code.ERR_EXPECTED_DATA_NOT_RECEIVED).model_dump(
                mode="json"
            ),
            status=400,
        )


def validate_json_bytestring(raw_payload: bytes, model: Type[T]) -> T:
    try:
        return model.model_validate_json(raw_payload)
    except PydanticValidationError as e:
        raise ValidationError(e.errors())
