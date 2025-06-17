## Development

### Installing

#### Backend

```bash
uv sync
```

#### API Docs

```bash
cd ./docs
pnpm install
```

### Development

#### Backend

```bash
uv run manage.py runserver
```

#### API Docs

```bash
cd ./docs
pnpm dev
```

#### Backend

```bash
uv run dev
```

### Codegen

```bash
datamodel-codegen --input ./docs/build/openapi.yaml --input-file-type openapi --output codegen --output-model-type pydantic_v2.BaseModel
```