from pydantic import BaseModel
from typing import TypeVar, Type


T = TypeVar("T", bound=BaseModel)


def validate_json_bytestring(raw_payload: bytes, model: Type[T]) -> T:
    return model.model_validate_json(raw_payload)
