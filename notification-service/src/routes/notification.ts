import * as controller from "../controller/notification";
import { Router } from "express";

const router = Router();
router.route("/email").post(controller.createEmailNotification);
router.route("/push").post(controller.createPushNotification);
router.route("/:userId").get(controller.getNotifications);

export default router;
