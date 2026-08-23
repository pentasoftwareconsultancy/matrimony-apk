import mongoose from "mongoose";

const reviewSchema = new mongoose.Schema({
  image: { type: String }, // image URL or path
  text: { type: String, required: true },
  rating: { type: Number, min: 1, max: 5, required: true }
});

const decorationSchema = new mongoose.Schema({
  name: { type: String, required: true },
  studio: { type: String, required: true },
  location: { type: String, required: true },
  projects: { type: String }, // e.g. "300+ Projects"
  phone: { type: String, required: true },
  detailname: { type: String }, // for detailed view if needed
  image: { type: String }, // main display image
  images: [{ type: String }], // gallery images
  about: { type: String, required: true },
  pricing: [{ type: String }], // pricing options
  specializations: [{ type: String }], // services offered
  reviews: [reviewSchema] // embedded reviews
}, { timestamps: true });

export default mongoose.model("Decoration", decorationSchema);
    