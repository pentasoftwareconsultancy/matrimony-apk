// models/LightingSchema.js
import mongoose from "mongoose";

// Review Subdocument Schema
const reviewSchema = new mongoose.Schema(
  {
    image: { type: String }, // review image URL (optional)
    text: { type: String, required: true }, // review text
    rating: { type: Number, min: 1, max: 5, required: true }, // rating out of 5
  },
  { _id: false }
);

// Main Lighting Schema
const lightingSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },         // e.g., Vikram Desai
    company: { type: String, required: true },      // e.g., Luminous Events
    location: { type: String, required: true },     // e.g., Mumbai
    project: { type: String, required: true },      // e.g., Wedding Lighting
    about: { type: String, required: true },        // description / bio

    image: { type: String },                        // main profile image
    images: [{ type: String }],                     // gallery images

    specializations: [{ type: String }],            // e.g., ["Wedding Lighting", "Stage Illumination"]
    pricing: [{ type: String }],                    // e.g., ["15K - Basic Wedding Lighting", "30K - Premium Wedding Lighting"]

    reviews: [reviewSchema],                        // array of reviews
  },
  { timestamps: true } // automatically adds createdAt & updatedAt
);

const Lighting = mongoose.model("Lighting", lightingSchema);

export default Lighting;
