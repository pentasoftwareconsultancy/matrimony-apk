import mongoose from "mongoose";

const favoriteSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",  // person who favorites
      required: true,
    },
    profileId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Matrimony",  // profile that is favorited
      required: true,
    },
    isFavorite: {
      type: Boolean,
      default: true, // if record exists = favorite
    },
  },
  { timestamps: true }
);

// Prevent duplicate favorites for same user-profile pair
favoriteSchema.index({ userId: 1, profileId: 1 }, { unique: true });

const Favorite = mongoose.model("Favorite", favoriteSchema);
export default Favorite;
