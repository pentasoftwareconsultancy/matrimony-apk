import mongoose from "mongoose";

const notificationSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",
      required: true,
    },
    type: {
      type: String,
      enum: ["match", "interest", "profileActivity"],
      default: "profileActivity",
    },
    message: { type: String, required: true },
    isRead: { type: Boolean, default: false },
    senderImage: { type: String },
  },
  { timestamps: true, collection: "notifications" }
);

const Notification = mongoose.models.Notification || mongoose.model("Notification", notificationSchema);
export default Notification;
