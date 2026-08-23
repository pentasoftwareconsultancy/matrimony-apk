import mongoose from "mongoose";

const reviewSchema = new mongoose.Schema({
  image: { type: String },
  text: { type: String, required: true },
  rating: { type: Number, min: 1, max: 5 }
});

const createVendorSchema = (collectionName) => {
  return new mongoose.Schema(
    {
      name: { type: String, required: true },
      studio: { type: String },
      location: { type: String },
      projects: { type: String },
      phone: { type: String },
      detailname: { type: String },
      image: { type: String },
      images: [{ type: String }],
      about: { type: String },
      pricing: { type: [String], default: [] },
      specializations: { type: [String], default: [] },
      reviews: [reviewSchema],
    },
    { timestamps: true, collection: collectionName }
  );
};

export const Photographer = mongoose.models.Photographer || mongoose.model("Photographer", createVendorSchema("photographers"));
export const Decoration = mongoose.models.Decoration || mongoose.model("Decoration", createVendorSchema("decorations"));
export const Mehendi = mongoose.models.Mehendi || mongoose.model("Mehendi", createVendorSchema("mehendis"));
export const Jewellery = mongoose.models.Jewellery || mongoose.model("Jewellery", createVendorSchema("jewelleries"));
export const Makeup = mongoose.models.Makeup || mongoose.model("Makeup", createVendorSchema("makeups"));
export const Lighting = mongoose.models.Lighting || mongoose.model("Lighting", createVendorSchema("lightings"));
export const DJMusic = mongoose.models.DJMusic || mongoose.model("DJMusic", createVendorSchema("djmusics"));

export default {
  Photographer,
  Decoration,
  Mehendi,
  Jewellery,
  Makeup,
  Lighting,
  DJMusic,
};
