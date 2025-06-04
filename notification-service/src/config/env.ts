import dotenv from "dotenv";
dotenv.config({ path: "./.env" });

export default {
  port: process.env.PORT,
  redis_url: process.env.REDIS_URL,
};
