import express from "express";
import bodyParser from "body-parser";
import authRoutes from "./routes/auth";

const app = express();

app.use(express.static("public"));
app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use("/auth", authRoutes);

export default app;
