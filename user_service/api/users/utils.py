import json


def validate_json_bytestring(raw_payload: bytes, model: BaseModel) -> BaseModel:
    payload = json.loads(raw_payload)
    validated_payload = model(payload)
    return validated_payload
