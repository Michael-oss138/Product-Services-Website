import config from "../config";
import mongoose from "mongoose";

export default function connectToDb() {
  return mongoose
    .connect(config.env.db_url!, {
      dbName: config.env.db_name,
    })
    .catch(console.error);
}
