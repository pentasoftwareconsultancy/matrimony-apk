import mongoose from "mongoose";

const reviewSchema = new mongoose.Schema({
  image: { type: String }, // URL or path
  text: { type: String, required: true },
  rating: { type: Number, min: 1, max: 5 }
});

const photographerSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    studio: { type: String },
    location: { type: String },
    projects: { type: String },
    phone: { type: String },
    detailname: { type: String },
    image: { type: String }, // main photo
    images: [{ type: String }], // multiple images
    about: { type: String },
    pricing: {
      type: [String], // array of strings
      default: []
    },
    specializations: {
      type: [String], // array of strings
      default: []
    },
    reviews: [reviewSchema]
  },
  { timestamps: true }
);

export default mongoose.model("Photographer", photographerSchema);
