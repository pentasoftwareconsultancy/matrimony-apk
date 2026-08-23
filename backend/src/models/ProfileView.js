import mongoose from "mongoose";

const profileViewSchema = new mongoose.Schema(
  {
    viewerUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",
      required: true,
    },
    viewedUserId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",
      required: true,
    },
    viewedProfileId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",
      required: true,
    },
  },
  {
    timestamps: true,
    collection: "profile_views",
  }
);

profileViewSchema.index({ viewedUserId: 1, viewerUserId: 1 });

const ProfileView = mongoose.models.ProfileView || mongoose.model("ProfileView", profileViewSchema);
export default ProfileView;
