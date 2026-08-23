import mongoose from "mongoose";

const registrationScheama = new mongoose.Schema({
  fullName: {
    type: String,
    required: true,
    trim: true,
  },
  dateOfBirth: { type: Date, required: true },
  phoneNumber: {
    type: Number,
    required: true,
    match: [
      /^\d{10}$/,
      "Phone number must be exactly 10 digits and contain only numbers",
    ],
  },
  email: {
    type: String,
    required: true,
    match: [
      /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
      "Please enter a valid email address",
    ],
  },
  password: {
    type: String,
    required: true,
    match: [
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/,
      "Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, and one number",
    ],
  },
  confirmPassword: {
    type: String,
    required: true,
    match: [/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/],
  },
  profileCreatedFor: {
    type: String,
    select: false,
    enum: ["Son", "Daughter", "Yourself", "Bride", "Groom"],
    required: true,
  },
  alternativePhoneNumber: {
    type: String,
    required: false,
    match: [
      /^\d{10}$/,
      "Phone number must be exactly 10 digits and contain only numbers",
    ],
  },
  pincode: {
    type: String,
    required: true,
    match: [
      /^\d{6}$/,
      "Pincode must be exactly 6 digits and contain only numbers",
    ],
  },
  address: { type: String, required: true },
  village: { type: String, required: true },
  taluka: { type: String, required: true },
  district: { type: String, required: true },
  state: { type: String, required: true },
  country: { type: String, required: true },
  // GEO JSON Location
  // location: {
  //   type: {
  //     type: String,
  //     enum: ["Point"],
  //     default: "Point",
  //     required: false
  //   },
  //   coordinates: {
  //     type: [Number], // [longitude, latitude]
  //     required: false
  //   }
  // }
});
// Add 2dsphere index for geo queries
registrationScheama.index({ location: "2dsphere" });

export default registrationScheama;
