import mongoose from "mongoose";

// MatchesGallery schema
const matchesGallerySchema = new mongoose.Schema(
  {
    description: { type: String, required: true },
    images: [{ type: String }] // gallery images
  },
  { timestamps: true }
);

export default mongoose.model("MatchesGallery", matchesGallerySchema);

