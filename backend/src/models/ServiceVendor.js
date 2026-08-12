import mongoose from 'mongoose';

const packageSchema = new mongoose.Schema({
  title: { type: String, required: true },
  price: { type: String, required: true },
});

const reviewSchema = new mongoose.Schema({
  author: { type: String, required: true },
  text: { type: String, required: true },
  rating: { type: Number, default: 5 },
  images: [{ type: String }],
});

const serviceVendorSchema = new mongoose.Schema(
  {
    category: {
      type: String,
      required: true,
      enum: ['photography', 'mehendi', 'decoration'],
      lowercase: true,
    },
    name: { type: String, required: true },
    subtitle: { type: String, required: true },
    location: { type: String, required: true },
    rating: { type: Number, default: 4.8 },
    projectCount: { type: String, default: '100+ projects' },
    priceRange: { type: String, required: true },
    phone: { type: String, required: true },
    whatsappNumber: { type: String, required: true },
    images: [{ type: String }],
    about: { type: String },
    packages: [packageSchema],
    specializations: [{ type: String }],
    reviews: [reviewSchema],
    isActive: { type: Boolean, default: true },
  },
  {
    timestamps: true,
    collection: 'service_vendors',
  }
);

const ServiceVendor = mongoose.model('ServiceVendor', serviceVendorSchema);
export default ServiceVendor;
