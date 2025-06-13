import { createApiReference } from "@scalar/api-reference";
import openapiYaml from "../build/openapi.yaml?raw";

createApiReference("#app", {
	content: openapiYaml,
});
