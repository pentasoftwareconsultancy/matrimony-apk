import mongoose from "mongoose";

const familydetailsSchema = new mongoose.Schema({
    fatherName: { type: String, required: true },
  // fatherEducation: { type: String, required: false },
  fatherOccupation: { type: String, required: false },
  motherName: { type: String, required: true },
  motherOccupation: { type: String, required: false },
  familyType: { type: String, required: true },
  familyValues: { type: String, required: true },
  nativePlace: { type: String, },
  brothers: { type: Number, required: true },
  marriedBrothers: { type: String, required: false },
  sisters: { type: Number, required: true },
  marriedSisters: { type: String, required: false },
  maternalUncleName: { type: String, required: false },
  maternalUnclePhone: {
    type: String,
    required: false,
    match: [/^\d{10}$/, "Phone number must be exactly 10 digits and contain only numbers"],
  },
  uncleName: { type: String, required: false },
  unclePhone: {
    type: String,
    required: false,
    match: [/^\d{10}$/, "Phone number must be exactly 10 digits and contain only numbers"],
  }
})


export default familydetailsSchema