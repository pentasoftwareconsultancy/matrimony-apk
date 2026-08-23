import mongoose from "mongoose";

const partnerPrefernceSchema = new mongoose.Schema({

    partnerMaritalStatus: { type: String, required: true },
    expectedAgeRange: {
    from: { type: Number },
    to: { type: Number},
  },
  partnerComplexionType: { type: String, required: true },
  partnerHeight: { type: Number, required: true },
  partnerWeight: { type: Number, required: false },
  partnerDiet: { type: String, required: true },
  partnerSmoking: { type: String, required: true },
  partnerDrinking: { type: String, required: true },
  partnerWorkingLocation: { type: String, required: true },
  partnerIncome: { type: Number, required: true },
  partnerEducation: { type: String, required: true },
  partnerProfession: { type: String, required: true },
  wantsWorkingPartner: { type: Boolean, required: true }
})

export default partnerPrefernceSchema