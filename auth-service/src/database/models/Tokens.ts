import mongoose, { Document, Model, Schema } from "mongoose";

interface TokenDocument extends Document {
  token: string;
  userId: string;
  createdAt: Date;
}
const TokenSchema: Schema<TokenDocument> = new Schema({
  token: {
    type: String,
    required: true,
  },
  userId: {
    type: String,
    required: true,
  },
  createdAt: {
    type: Date,
    required: true,
    default: mongoose.now(),
  },
});

const Token: Model<TokenDocument> = mongoose.model<TokenDocument>(
  "Token",
  TokenSchema
);

export default Token;
