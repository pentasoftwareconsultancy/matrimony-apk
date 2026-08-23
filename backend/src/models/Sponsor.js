import mongoose from "mongoose";

const linkSchema = new mongoose.Schema(
  {
    urlweb: { type: String },
    urlinsta: { type: String },
    urltwit: { type: String },
  },
  { _id: false }
);

const sponsorSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    src: { type: String, required: true },
    description: { type: String },
    images: [{ type: String }],
    links: [linkSchema],
  },
  { timestamps: true, collection: "sponsors" }
);

const Sponsor = mongoose.models.Sponsor || mongoose.model("Sponsor", sponsorSchema);
export default Sponsor;
