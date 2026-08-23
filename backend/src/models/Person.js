import mongoose from "mongoose";

const personSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    designation: { type: String, required: true },
    age: { type: Number, required: true },
    location: { type: String, required: true },
    place: { type: String, required: true },
    experience: { type: Number, required: true },
    biography: { type: String, required: true },
    image: { type: String },
  },
  { timestamps: true, collection: "people" }
);

const Person = mongoose.models.Person || mongoose.model("Person", personSchema);
export default Person;
