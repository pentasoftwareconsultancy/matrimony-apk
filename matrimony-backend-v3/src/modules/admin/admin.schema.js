


import mongoose from "mongoose";
import bcrypt from "bcryptjs";

const adminSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    unique: true,
    trim: true,
    required: true,
    match: [
      /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
      "Please enter a valid email address",
    ],
    validate: {
      validator: function(email) {
        // This will be checked in controller, but added as extra validation
        const allowedEmails = process.env.ALLOWED_ADMIN_EMAILS 
          ? process.env.ALLOWED_ADMIN_EMAILS.split(',').map(e => e.trim().toLowerCase())
          : [];
        return allowedEmails.includes(email.toLowerCase());
      },
      message: "This email is not authorized for admin registration"
    }
  },
  mobileNumber: {
    type: Number,
    unique: true,
    match: [/^[0-9]{10}$/, "Mobile number must be 10 digits"],
  },
  password: {
    type: String,
    required: true,
    match: [
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/,
      "Password must be at least 6 characters long, contain at least one uppercase letter, one lowercase letter, and one number",
    ],
  },
  role: {
    type: String,
    enum: ["admin"],
    default: "admin",
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// Before saving password hashed
adminSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

// Compare password
adminSchema.methods.comparePassword = async function (plainTextPassword) {
  return bcrypt.compare(plainTextPassword, this.password);
};

export default mongoose.model("Admin", adminSchema);