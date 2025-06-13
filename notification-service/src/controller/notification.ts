import { NotificationType } from "../models/Notification";
import redisService from "../service/redis/redisService";
import EmailService from "../service/notification/EmailService";
import { Hono } from "hono";
import validations from "../validations";
import emailSchema from "../validations/schemas/emailSchema";
import pushSchema from "../validations/schemas/pushSchema";

export const createNotification = new Hono()
  .post("/email", validations(emailSchema), async (c) => {
    const { name, email, subject, message } = c.req.valid("json");
    const emailService = new EmailService(name, email, subject, message);
    await emailService.sendSingleEmail();
    return c.json({ success: true, message: "Notification sent!" });
  })
  .post("/push", validations(pushSchema), async (c) => {
    const notificationData: NotificationType = c.req.valid("json");
    await redisService.saveNotification(notificationData);
    return c.json({ success: true, message: "Notification sent!" });
  })
  .get("/:userId", async (c) => {
    const userId = c.req.param("userId");
    const notifications = await redisService.getNotifications(userId);
    return c.json({
      success: true,
      message: "Notifications retrieved",
      data: notifications,
    });
  });
