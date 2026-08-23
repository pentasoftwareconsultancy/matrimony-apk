import mongoose from "mongoose";

// Review sub-schema
const reviewSchema = new mongoose.Schema({
  image: { type: String }, 
  text: { type: String, required: true }, 
  rating: { type: Number, min: 1, max: 5, required: true } 
});

// Makeup Schema
const makeupSchema = new mongoose.Schema(
  {
    name: { type: String, required: true }, 
    studio: { type: String, required: true }, 
    location: { type: String, required: true },
    project: { type: String },

    phone: { type: String },       // optional contact
    detailname: { type: String },  // optional detailed display name

    image: { type: String },       // profile image
    images: [{ type: String }],    // gallery images

    about: { type: String, required: true }, // bio/description
    pricing: [{ type: String }],// structured objects
    specializations: [{ type: String }],     // services offered

    reviews: [reviewSchema],                 // array of reviews
  },
  { timestamps: true }
);

export default mongoose.model("Makeup", makeupSchema);
