import { createEnv } from "@t3-oss/env-core";
import { z } from "zod";

export const env = createEnv({
	clientPrefix: "VITE_",
	client: {
		VITE_USER_SERVICE_URL: z.string().url(),
	},
	server: {},
	runtimeEnv: import.meta.env,
});
