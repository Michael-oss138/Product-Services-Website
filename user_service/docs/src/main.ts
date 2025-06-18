import { createApiReference } from "@scalar/api-reference";
import openapiYaml from "../build/openapi.yaml?raw";
import { env } from "./env";

createApiReference("#app", {
	content: openapiYaml,
	servers: [
		{
			url: env.VITE_USER_SERVICE_URL,
			description: "User Service",
		},
	],
});
