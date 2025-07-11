import dotenv from "dotenv";
dotenv.config();
const env = process.env;
export default {
  port: env.PORT,
  db_url: env.DATABASE_URL,
  db_name: env.DATABASE_NAME,
  jwt_secret: env.JWT_SECRET_KEY,
  access_exp: env.ACCESS_TOKEN_EXP,
  refresh_exp: env.REFRESH_TOKEN_EXP,
};
