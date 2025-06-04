import app from "./app";
import { createServer } from "http";
import env from "./config/env";

const server = createServer(app);
server.listen(env.port);
server.on("listening", () => {
  console.log(`Listening on port: ${env.port}`);
});
server.on("error", (err) => {
  console.error(err);
});
