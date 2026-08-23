import mongoose from 'mongoose';

const testimonialSchema = new mongoose.Schema({
  coupleNames: {
    type: String,
    required: true,
  },
  weddingDate: {
    type: String,
    required: true,
  },
  image: {
    type: String,
    required: true,
  },
  story: {
    type: String,
    required: true,
  },
  rating: {
    type: Number,
    default: 5.0,
  },
  isActive: {
    type: Boolean,
    default: true,
  },
}, {
  timestamps: true,
  collection: 'testimonials'
});

const Testimonial = mongoose.model('Testimonial', testimonialSchema);
export default Testimonial;
