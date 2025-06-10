import app from "./app";
import { createServer } from "http";
import config from "./config";
import connectToDb from "./database";
const server = createServer(app);

connectToDb().then(() => server.listen(config.env.port));
server.on("listening", () => {
  console.log(`Server is running on port : ${config.env.port}`);
});
