import { Hono } from "hono";
import notificationRoutes from "./routes/notification";
const app = new Hono();
import { logger } from "hono/logger";

app.use(logger());
app.route("/notifications", notificationRoutes);

export default app;
