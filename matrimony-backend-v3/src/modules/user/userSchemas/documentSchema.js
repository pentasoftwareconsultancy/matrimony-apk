import mongoose from "mongoose";

const documentationSchema = new mongoose.Schema({

        aadharCardNumber: {
        type: String,
        // required: true,
        match: [/^\d{12}$/, "Aadhar number must be exactly 12 digits and contain only numbers"],
    },
    panCardNumber: {
        type: String,
        // required: true,
        match: [/^[A-Z]{5}[0-9]{4}[A-Z]$/, "PAN number must be in format XXXXX9999X"],
    },
    passportNumber: { type: String, required: false },
    aadhaarFrontphoto: { type: String, required: false },
    aadhaarBackphoto: { type: String, required: false },
    panFrontphoto: { type: String, required: false },
    panBackphoto: { type: String, required: false },
    highestEducationalDoc: { type: String, required: false },
    castecertificate:{type: String, require:false},
    passportFrontphoto: { type: String, required: false },
    passportBackphoto: { type: String, required: false },
    photoFulls: { type: String, required: false },
    photoCloseup: { type: String, required: false },
    photoFull: { type: String, required: false },
    familyPhoto: { type: String, required: false }
})


export default documentationSchema