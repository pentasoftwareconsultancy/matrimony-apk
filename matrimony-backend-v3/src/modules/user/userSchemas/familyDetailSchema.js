import mongoose from "mongoose";

const brotherDetailSchema = new mongoose.Schema({
  name: { type: String, default: '' },
  occupation: { type: String, default: '' },
}, { _id: false });

const sisterDetailSchema = new mongoose.Schema({
  name: { type: String, default: '' },
  occupation: { type: String, default: '' },
  isMarried: { type: Boolean, default: false },
  husbandName: { type: String, default: '' },
  husbandProfession: { type: String, default: '' },
}, { _id: false });

const uncleDetailSchema = new mongoose.Schema({
  name: { type: String, default: '' },
  occupation: { type: String, default: '' },
}, { _id: false });

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
  },
  brothersDetails: { type: [brotherDetailSchema], default: [] },
  sistersDetails: { type: [sisterDetailSchema], default: [] },
  maternalUnclesDetails: { type: [uncleDetailSchema], default: [] },
  unclesDetails: { type: [uncleDetailSchema], default: [] },
})


export default familydetailsSchema
