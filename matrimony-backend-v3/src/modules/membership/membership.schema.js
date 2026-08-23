import mongoose from "mongoose";

// Membership Schema
const MembershipSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "Matrimony", required: true },

  planType: { 
    type: String, 
    enum: ["Silver", "Gold", "Platinum", "Free"], 
    required: true 
  },

  amount: { type: Number, required: true },
  currency: { type: String, default: "INR" },

  // Razorpay fields
  orderId: { type: String },    // Razorpay order ID
  paymentId: { type: String },  // Razorpay payment ID
  status: { 
    type: String, 
    enum: ["created", "paid", "failed"], 
    default: "created" 
  },

  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
  
  // Membership expiry
  expiryDate: { type: Date },  // only required if status is "paid"
});

// Auto-update updatedAt before save
MembershipSchema.pre("save", function (next) {
  this.updatedAt = Date.now();
  next();
});

export default mongoose.model("Membership", MembershipSchema);
