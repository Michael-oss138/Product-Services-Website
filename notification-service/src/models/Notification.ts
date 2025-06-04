export interface NotificationType {
  channel: string;
  type: string;
  user: {
    id: string;
    name: string;
    email: string;
  };
  created_on: Date;
  updated_on: Date;
  read: boolean;
}
