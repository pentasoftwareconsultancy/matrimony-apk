import mongoose from "mongoose";

const messageSchema = new mongoose.Schema(
  {
    sender: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",
      required: true,
      index: true,
    },

    receiver: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",
      required: true,
      index: true,
    },

    content: {
      type: String,
      required: true,
      trim: true,
    },

    // Message lifecycle:
    // sent → delivered → read
    status: {
      type: String,
      enum: ["sent", "delivered", "read"],
      default: "sent",
      index: true,
    },

    // Set when receiver's device receives the message
    deliveredAt: {
      type: Date,
      default: null,
    },

    // Set when receiver actually opens/reads the conversation
    readAt: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
    collection: "messages",
  }
);

// Useful for fetching a conversation efficiently
messageSchema.index({
  sender: 1,
  receiver: 1,
  createdAt: 1,
});

messageSchema.index({
  receiver: 1,
  sender: 1,
  createdAt: 1,
});

const Message =
  mongoose.models.Message ||
  mongoose.model("Message", messageSchema);

export default Message;