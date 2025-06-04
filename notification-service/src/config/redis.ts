import { createClient } from "redis";
import env from "./env";

const client = createClient({
  url: env.redis_url,
});

client.on("error", (err) => {
  console.error("REDIS error occured ", err);
});

(async () => {
  const connected = await client.connect();
})();

export default client;
