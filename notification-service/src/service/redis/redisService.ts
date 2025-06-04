import client from "../../config/redis";
import { NotificationType } from "../../models/Notification";

class RedisService {
  async saveNotification(notification: NotificationType) {
    let key = `Notification:${notification.user.id}`;
    let value = JSON.stringify(notification);
    await client.lPush(key, value);
  }
  async getNotifications(userId: string): Promise<string[]> {
    let key = `Notification:${userId}`;
    let notifications = await client.lRange(key, 0, -1);
    return notifications.map((n) => JSON.parse(n));
  }
}

export default new RedisService();
