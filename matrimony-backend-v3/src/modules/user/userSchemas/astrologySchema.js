import mongoose from "mongoose";

const astrologySchema = new mongoose.Schema({
    motherTongue: { type: String, required: true },
    religion: { type: String, required: true },
    caste: { type: String, required: true },
    subCast: { type: String },
    placeOfBirth: { type: String, required: true },
    timeOfBirth: { type: String, required: true },
    rashi: { type: String},
    gotra: { type: String },
    gan: { type: String },
    nadi: { type: String },
    charan: { type: String },
    nakshatra: { type: String },
    isManglik: { type: Boolean },
    importanceOfPatrika: {
        type: Number,
        required: false, // Made optional to avoid min: 1 error
        get: (value) => (value ? Array(value).fill("★").concat(Array(5 - value).fill("☆")).join("") : "☆☆☆☆☆"),
    }
})

export default  astrologySchema