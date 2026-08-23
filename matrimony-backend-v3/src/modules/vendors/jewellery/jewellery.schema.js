import mongoose from "mongoose";

const jewellerySchema = new mongoose.Schema({
  name: { type: String, required: true },
  company: String,
  location: String,
  phone: Number,
  project: String,
  about: String,
  image: String,
  images: [String],
  specializations: [String],
  pricing: [String],
  reviews: [
    {
      text: String,
      rating: Number,
      image: String,
    },
  ],
}, { timestamps: true });

// ✅ Use a unique model name
const Jewellery = mongoose.models.Jewellery || mongoose.model("Jewellery", jewellerySchema);

export default Jewellery;
