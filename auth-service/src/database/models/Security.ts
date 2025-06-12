import mongoose, { Model, Schema, Document } from "mongoose";
import Encryption from "../../utils/Encryption";
const encrypt = new Encryption();

export interface SecurityDocument extends Document {
  userId: string;
  role: string;
  password: string;
  resetToken: string;
  resetTokenExpires: Date;
  createdAt: Date;
  updatedAt: Date;
  isModified: (path?: string) => boolean;
}

const SecuritySchema: Schema<SecurityDocument> = new Schema<SecurityDocument>({
  userId: {
    type: String,
    unique: true,
    required: [true, "User Id cannot be null"],
  },
  role: {
    type: String,
    required: true,
  },
  password: {
    required: [true, "Password field is required"],
    type: String,
  },
  resetToken: {
    type: String,
  },
  resetTokenExpires: {
    type: Date,
  },
  createdAt: {
    type: Date,
    required: true,
    default: mongoose.now(),
  },
  updatedAt: {
    type: Date,
    required: true,
    default: mongoose.now(),
  },
});

SecuritySchema.pre("save", async function (next) {
  try {
    if (this.isNew || this.isModified("password")) {
      this.password = await encrypt.hashInput(this.password);
    }
    next();
  } catch (error) {
    next(<Error>error);
  }
});
const Security: Model<SecurityDocument> = mongoose.model<SecurityDocument>(
  "Security",
  SecuritySchema
);

export default Security;
