import mongoose from "mongoose";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";
import { getJwtSecret } from "../config/jwt.js";

const registrationSchema = new mongoose.Schema({
  fullName: { type: String, required: true, trim: true },
  dateOfBirth: { type: Date, required: true },
  phoneNumber: {
    type: Number,
    required: true,
  },
  email: {
    type: String,
    required: true,
    trim: true,
    lowercase: true,
  },
  password: {
    type: String,
    required: true,
  },
  profileCreatedFor: {
    type: String,
    enum: [
      "Son",
      "Daughter",
      "Yourself",
      "Bride",
      "Groom",
      "Self",
      "Relative",
      "Friend",
      "Parent",
      "Guardian",
      "Sibling",
    ],
    default: "Yourself",
  },
  alternativePhoneNumber: { type: String, required: false },
  pincode: { type: String, required: false },
  address: { type: String, required: false },
  village: { type: String, required: false },
  taluka: { type: String, required: false },
  district: { type: String, required: false },
  state: { type: String, required: false },
  country: { type: String, required: false },
});

const personalDetailSchema = new mongoose.Schema({
  gender: { type: String, required: true, enum: ["Bride", "Groom", "Male", "Female", "Other"] },
  maritalStatus: { type: String, required: false },
  numberOfChildren: { type: Number, default: 0 },
  age: { type: Number, required: false },
  height: { type: Number, required: false },
  weight: { type: Number, required: false },
  complexionType: { type: String, required: false },
  bloodGroup: { type: String, required: false },
  specialCase: { type: String, required: false },
  bodyType: { type: String, required: false },
  diet: { type: String, required: false },
  smoking: { type: String, required: false },
  drinking: { type: String, required: false },
  hobbies: { type: mongoose.Schema.Types.Mixed, required: false },
  agriculturalLandAcres: { type: String, required: false },
  descriptionAboutSelf: { type: String, required: false },
});

const educationSchema = new mongoose.Schema({
  highestEducation: { type: String, required: false },
  educationField: { type: String, required: false },
  universityCollege: { type: String, required: false },
  profession: { type: String, required: false },
  occupationPosition: { type: String, required: false },
  organizationName: { type: String, required: false },
  companyAddress: { type: String, required: false },
  annualIncome: { type: mongoose.Schema.Types.Mixed, required: false },
});

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
  fatherName: { type: String, required: false },
  fatherOccupation: { type: String, required: false },
  motherName: { type: String, required: false },
  motherOccupation: { type: String, required: false },
  familyType: { type: String, required: false },
  familyValues: { type: String, required: false },
  familyStatus: { type: String, required: false },
  nativePlace: { type: String, required: false },
  brothers: { type: Number, default: 0 },
  marriedBrothers: { type: String, required: false },
  sisters: { type: Number, default: 0 },
  marriedSisters: { type: String, required: false },
  maternalUncleName: { type: String, required: false },
  maternalUnclePhone: { type: String, required: false },
  uncleName: { type: String, required: false },
  unclePhone: { type: String, required: false },
  aboutFamily: { type: String, required: false },
  brothersDetails: { type: [brotherDetailSchema], default: [] },
  sistersDetails: { type: [sisterDetailSchema], default: [] },
  maternalUnclesDetails: { type: [uncleDetailSchema], default: [] },
  unclesDetails: { type: [uncleDetailSchema], default: [] },
});

const astrologySchema = new mongoose.Schema({
  motherTongue: { type: String, required: false },
  religion: { type: String, required: false },
  caste: { type: String, required: false },
  subCast: { type: String, required: false },
  placeOfBirth: { type: String, required: false },
  timeOfBirth: { type: String, required: false },
  rashi: { type: String, required: false },
  gotra: { type: String, required: false },
  gan: { type: String, required: false },
  nadi: { type: String, required: false },
  charan: { type: String, required: false },
  nakshatra: { type: String, required: false },
  isManglik: { type: Boolean, default: false },
  importanceOfPatrika: { type: mongoose.Schema.Types.Mixed, required: false },
});

const partnerPreferenceSchema = new mongoose.Schema({
  partnerMaritalStatus: { type: String, required: false },
  expectedAgeRange: {
    from: { type: Number },
    to: { type: Number },
  },
  partnerComplexionType: { type: String, required: false },
  partnerHeight: { type: Number, required: false },
  partnerWeight: { type: Number, required: false },
  partnerDiet: { type: String, required: false },
  partnerSmoking: { type: String, required: false },
  partnerDrinking: { type: String, required: false },
  partnerWorkingLocation: { type: String, required: false },
  partnerIncome: { type: mongoose.Schema.Types.Mixed, required: false },
  partnerEducation: { type: String, required: false },
  partnerProfession: { type: String, required: false },
  wantsWorkingPartner: { type: Boolean, default: false },
});

const documentationSchema = new mongoose.Schema({
  aadharCardNumber: { type: String, required: false },
  panCardNumber: { type: String, required: false },
  passportNumber: { type: String, required: false },
  aadhaarFrontphoto: { type: String, required: false },
  aadhaarBackphoto: { type: String, required: false },
  panFrontphoto: { type: String, required: false },
  panBackphoto: { type: String, required: false },
  highestEducationalDoc: { type: String, required: false },
  castecertificate: { type: String, required: false },
  passportFrontphoto: { type: String, required: false },
  passportBackphoto: { type: String, required: false },
  photoFulls: { type: String, required: false },
  photoCloseup: { type: String, required: false },
  photoFull: { type: String, required: false },
  familyPhoto: { type: String, required: false },
  photos: [{ type: String }],
});

const matrimonySchema = new mongoose.Schema(
  {
    approvalStatus: {
      type: String,
      enum: ["Pending", "Approved", "Denied"],
      default: "Approved",
    },
    denialReason: {
      type: String,
      default: "",
    },
    userRegistration: registrationSchema,
    personalDetail: personalDetailSchema,
    educationalDetail: educationSchema,
    familyDetails: familydetailsSchema,
    astrologyDetails: astrologySchema,
    partnerDetail: partnerPreferenceSchema,
    documentDetails: documentationSchema,
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now },
    lastSeenAt: {
      type: Date,
      default: null,
    },
  },
  {
    strict: false,
    collection: "matrimonies",
  }
);

// Method to generate JWT token
matrimonySchema.methods.jwtToken = function () {
  const token = jwt.sign(
    {
      id: this._id,
      email: this.userRegistration?.email,
      role: "user",
    },
    getJwtSecret(),
    { expiresIn: "30d" }
  );
  return token;
};

// Method to compare password (supports bcrypt hashed passwords and legacy plain text)
matrimonySchema.methods.comparePassword = async function (plainTextPassword) {
  const storedPassword = this.userRegistration?.password;
  if (!storedPassword || typeof storedPassword !== "string") return false;
  if (storedPassword.startsWith("$2")) {
    return await bcrypt.compare(plainTextPassword, storedPassword);
  }
  return plainTextPassword === storedPassword;
};

// Pre-save hook to hash password if modified and ensure confirmPassword is never persisted
matrimonySchema.pre("save", async function (next) {
  if (this.userRegistration && "confirmPassword" in this.userRegistration) {
    this.userRegistration.confirmPassword = undefined;
  }
  if (this.isModified("userRegistration.password") && this.userRegistration?.password) {
    if (!this.userRegistration.password.startsWith("$2")) {
      this.userRegistration.password = await bcrypt.hash(this.userRegistration.password, 10);
    }
  }
  this.updatedAt = Date.now();
  next();
});

const Matrimony = mongoose.models.Matrimony || mongoose.model("Matrimony", matrimonySchema);
export default Matrimony;
