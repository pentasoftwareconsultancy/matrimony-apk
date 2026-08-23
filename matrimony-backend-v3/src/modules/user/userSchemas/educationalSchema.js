import mongoose from "mongoose";

const educationSchema = new mongoose.Schema({
highestEducation: { type: String, required: true },
  educationField: { type: String, required: true },
  universityCollege: { type: String, required: false },
  profession: { type: String, required: true },
  occupationPosition: { type: String, required: false },
  organizationName: { type: String, required: false },
  companyAddress: { type: String, required: false },
  annualIncome: { type: Number, required: true }
})


export default  educationSchema