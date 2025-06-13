import { zValidator } from "@hono/zod-validator";
import { z, ZodRawShape } from "zod";

export default function <T extends ZodRawShape>(s: z.ZodObject<T>) {
  return zValidator("json", s);
}
