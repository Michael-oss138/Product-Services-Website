import catchAsync from "../utils/catchAsync";
import { NotificationType } from "../models/Notification";
import redisService from "../service/redis/redisService";

export const createEmailNotification = catchAsync(async (req, res) => {
  const notificationData: NotificationType = req.body;
  await redisService.saveNotification(notificationData);
  res.status(201).json({ success: true, message: "Notification sent!" });
});

export const createPushNotification = catchAsync(async (req, res) => {
  const notificationData: NotificationType = req.body;
  await redisService.saveNotification(notificationData);
  res.status(201).json({ success: true, message: "Notification sent!" });
});
export const getNotifications = catchAsync(async (req, res) => {
  const userId = req.params.userId;
  const notifications = await redisService.getNotifications(userId);
  res.status(200).json({
    success: true,
    message: "Notifications retrieved",
    data: notifications,
  });
});
