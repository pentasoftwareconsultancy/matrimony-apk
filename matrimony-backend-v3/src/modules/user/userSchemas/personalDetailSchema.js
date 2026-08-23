
import mongoose from "mongoose";

const personalDetailSchema = new mongoose.Schema({
  gender: { type: String, required: true, enum: ["Bride", "Groom", "Other"] },
  maritalStatus: { type: String, required: true },
  numberOfChildren: { type: Number, required: true },
  age: { type: Number, required: true },
  height: { type: Number, required: true },
  weight: { type: Number, required: true },
  complexionType: { type: String, required: true },
  bloodGroup: { type: String, required: true },
  specialCase: { type: String, required: false },
  bodyType: { type: String, required: false },
  diet: { type: String, required: true },
  smoking: { type: String, required: true },
  drinking: { type: String, required: true },
  hobbies: { type: String, required: false },
  agriculturalLandAcres: { type: String, required: false },
  descriptionAboutSelf: { type: String, required: false },
})

export default personalDetailSchema