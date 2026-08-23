// models/Sponsor.js
import mongoose from 'mongoose';

const linkSchema = new mongoose.Schema({
  urlweb: { type: String },
  urlinsta: { type: String },
  urltwit: { type: String }
}, { _id: false }); // avoid auto _id for subdocs

const sponsorSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  src: { // main image
    type: String,
    required: true
  },
  description: {
    type: String
  },
  images: [{ type: String }], // gallery images
  links: [linkSchema] // array of link objects
}, { timestamps: true });

export default mongoose.model('Sponsor', sponsorSchema);
