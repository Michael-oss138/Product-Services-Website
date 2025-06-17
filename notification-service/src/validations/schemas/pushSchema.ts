import z from "zod";

const pushSchema = z.object({
  userid: z.string(),
  channel: z.string(),
  created_on: z.string(),
  read: z.boolean(),
  title: z.string(),
  message: z.string(),
});

export default pushSchema;
