import * as controller from "../controller/notification";
import { Hono } from "hono";

const router = new Hono();
router.route("/", controller.createNotification);

export default router;
