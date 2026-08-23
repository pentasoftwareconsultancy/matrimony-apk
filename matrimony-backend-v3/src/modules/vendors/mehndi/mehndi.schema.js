import mongoose from "mongoose";

// Review sub-schema
const reviewSchema = new mongoose.Schema({
  image: { type: String }, // image URL or path
  text: { type: String, required: true },
  rating: { type: Number, min: 1, max: 5, required: true }
});

// Mehendi Artist schema
const mehendiSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    studio: { type: String, required: true },
    location: { type: String, required: true },
    projects: { type: String }, // e.g. "300+ Projects"
    phone: { type: String, required: true },
    detailname: { type: String }, 
    image: { type: String }, // main profile image
    images: [{ type: String }], // gallery images
    about: { type: String, required: true }, // detailed description
    pricing: [{ type: String }], // pricing options like "10K - two Hands"
    specializations: [{ type: String }], // e.g. Arabic, Indian Tradition
    reviews: [reviewSchema] // embedded reviews
  },
  { timestamps: true }
);

export default mongoose.model("Mehendi", mehendiSchema);
