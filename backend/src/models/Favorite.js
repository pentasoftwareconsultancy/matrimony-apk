import mongoose from "mongoose";

const favoriteSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",
      required: true,
    },
    profileId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",
      required: true,
    },
    isFavorite: {
      type: Boolean,
      default: true,
    },
  },
  { timestamps: true, collection: "favorites" }
);

favoriteSchema.index({ userId: 1, profileId: 1 }, { unique: true });

const Favorite = mongoose.models.Favorite || mongoose.model("Favorite", favoriteSchema);
export default Favorite;
