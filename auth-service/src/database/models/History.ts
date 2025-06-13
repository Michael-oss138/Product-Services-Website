import mongoose, { Document, Schema, Model } from "mongoose";

interface HistoryDocument extends Document {
  ipAddress: string;
  device: string;
  userId: string;
  createdOn: Date;
}

const HistorySchema: Schema<HistoryDocument> = new Schema({
  ipAddress: {
    type: String,
    required: [true, "Ip address must be provided"],
  },
  device: {
    type: String,
    required: [true, "Device must be provided"],
  },
  userId: {
    type: String,
    required: [true, "User ID must be provided"],
  },
  createdOn: {
    type: Date,
    required: true,
    default: mongoose.now(),
  },
});

const History: Model<HistoryDocument> = mongoose.model<HistoryDocument>(
  "History",
  HistorySchema
);
export default History;
