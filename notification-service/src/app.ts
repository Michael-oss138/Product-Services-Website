import express from "express";
import bodyParser from "body-parser";
import notificationRoutes from "./routes/notification";
const app = express();

app.use(express.static("public"));
app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use("/notifications", notificationRoutes);

export default app;
