import app from "./app";
import { serve } from "@hono/node-server";
import env from "./config/env";

const server = serve({ port: Number(env.port!), fetch: app.fetch });
server.on("listening", () => {
  console.log(`Listening on port: ${env.port}`);
});
server.on("error", (err) => {
  console.error(err);
});
