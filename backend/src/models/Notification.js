import mongoose from "mongoose";

const notificationSchema = new mongoose.Schema(
  {
    // ============================================================
    // USER WHO RECEIVES THE NOTIFICATION
    // ============================================================

    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",
      required: true,
      index: true,
    },

    // ============================================================
    // USER WHO CAUSED THE NOTIFICATION
    // ============================================================

    actorUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",
      required: false,
      index: true,
    },

    // ============================================================
    // PROFILE RELATED TO THE NOTIFICATION
    //
    // For profileActivity:
    // this is the profile that should open when tapped.
    // ============================================================

    profileId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",
      required: false,
      index: true,
    },

    // ============================================================
    // NOTIFICATION TYPE
    // ============================================================

    type: {
      type: String,
      enum: [
        "match",
        "interest",
        "profileActivity",
      ],
      default: "profileActivity",
      index: true,
    },

    // ============================================================
    // NOTIFICATION TITLE
    // ============================================================

    title: {
      type: String,
      required: true,
      trim: true,
      maxlength: 100,
    },

    // ============================================================
    // NOTIFICATION MESSAGE
    // ============================================================

    message: {
      type: String,
      required: true,
      trim: true,
      maxlength: 500,
    },

    // ============================================================
    // ACTOR PROFILE IMAGE
    // ============================================================

    senderImage: {
      type: String,
      default: "",
      trim: true,
    },

    // ============================================================
    // READ STATUS
    // ============================================================

    isRead: {
      type: Boolean,
      default: false,
      index: true,
    },
  },
  {
    timestamps: true,
    collection: "notifications",
  }
);

// ================================================================
// USER NOTIFICATIONS — NEWEST FIRST
// ================================================================

notificationSchema.index({
  user: 1,
  createdAt: -1,
});

// ================================================================
// UNREAD NOTIFICATIONS
// ================================================================

notificationSchema.index({
  user: 1,
  isRead: 1,
  createdAt: -1,
});

// ================================================================
// PROFILE VIEW NOTIFICATION LOOKUP
//
// Used when checking whether the same viewer already generated
// a profile-view notification for the same recipient/profile.
// ================================================================

notificationSchema.index({
  user: 1,
  actorUserId: 1,
  profileId: 1,
  type: 1,
  createdAt: -1,
});

// ================================================================
// MODEL
// ================================================================

const Notification =
  mongoose.models.Notification ||
  mongoose.model("Notification", notificationSchema);

export default Notification;