import mongoose from "mongoose";

const djMusicSchema = new mongoose.Schema({
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
const DJMusic = mongoose.models.DJMusic || mongoose.model("DJMusic", djMusicSchema);

export default DJMusic;
