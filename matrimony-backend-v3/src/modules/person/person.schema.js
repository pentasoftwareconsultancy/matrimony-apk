

import mongoose from "mongoose";

const personSchema = new mongoose.Schema({
  name: { type: String, required: true },
  designation: { type: String, required: true },
  age: { type: Number, required: true, min: 0, max: 120 },
  location: { type: String, required: true },
  place: { 
    type: String, 
    enum: ["Pune", "Akole"],
    required: true 
  },
  experience: { type: Number, required: true, min: 0 },
  biography: { type: String, required: true, maxlength: 2000 },
  image: { type: String }, // single image (profile photo)
}, { timestamps: true });

const Person = mongoose.models.Person || mongoose.model("Person", personSchema);
export default Person;