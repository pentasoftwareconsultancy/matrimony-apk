
import mongoose from "mongoose";

const notificationSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony", // receiver user
      required: true,
    },

    type: {
      type: String,
      enum: ["match", "interest", "profileActivity"],
      required: true,
    },

    message: { type: String, required: true },

    isRead: { type: Boolean, default: false },
    senderImage: { type: String } // If stored in notification
  },
  { timestamps: true }
);

export default mongoose.model("Notification", notificationSchema);
