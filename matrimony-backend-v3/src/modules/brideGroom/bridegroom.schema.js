
import mongoose from "mongoose";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";

// Import sub-schemas
import registrationSchema from "../user/userSchemas/registrationSchema.js";
import personalDetailSchema from "../user/userSchemas/personalDetailSchema.js";
import familyDetailSchema from "../user/userSchemas/familyDetailSchema.js";
import parternPreferenceSchema from "../user/userSchemas/parternPreferenceSchema.js";
import educationalSchema from "../user/userSchemas/educationalSchema.js";
import documentSchema from "../user/userSchemas/documentSchema.js";
import astrologySchema from "../user/userSchemas/astrologySchema.js";
import strict from "assert/strict";

const matrimonySchema = new mongoose.Schema({
  approvalStatus: {
    type: String,
    enum: ["Pending", "Approved", "Denied"],
    default: "Pending",
  },
  denialReason: {
    type: String,
    default: "",
  },
  userRegistration: registrationSchema,
  personalDetail: personalDetailSchema,
  educationalDetail: educationalSchema,
  familyDetails: familyDetailSchema,
  astrologyDetails: astrologySchema,
  partnerDetail: parternPreferenceSchema,
  documentDetails: documentSchema,
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
},
  {
    strict: false,   // 🔥 THIS IS WHERE IT GOES
  }
);

// Generate JWT token with 24-hour expiration
matrimonySchema.methods.jwtToken = function () {
  const token = jwt.sign(
    {
      id: this._id,
      email: this.userRegistration.email,
      role: "user",
    },
    process.env.JWT_SECRET,
    { expiresIn: "24h" }
  );
  console.log("Generated Token:", token); // Debug
  return token;
};

// Compare password
matrimonySchema.methods.comparePassword = async function (plainTextPassword) {
  return await bcrypt.compare(plainTextPassword, this.userRegistration.password);
};

// Hash password before saving
matrimonySchema.pre("save", async function (next) {
  if (this.isModified("userRegistration.password")) {
    console.log("Hashing password for user:", this.userRegistration.email);
    this.userRegistration.password = await bcrypt.hash(
      this.userRegistration.password,
      10
    );
  }
  next();
});

export default mongoose.model("Matrimony", matrimonySchema);