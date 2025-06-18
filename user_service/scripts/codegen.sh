#!/usr/bin/env bash

datamodel-codegen \
    --input ./docs/build/openapi.yaml \
    --input-file-type openapi \
    --output codegen \
    --output-model-type pydantic_v2.BaseModel \
    --enum-field-as-literal all
