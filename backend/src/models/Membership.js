import mongoose from "mongoose";

const membershipSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: "Matrimony", required: true },
    planType: {
      type: String,
      enum: ["Silver", "Gold", "Platinum", "Free"],
      required: true,
    },
    amount: { type: Number, required: true },
    currency: { type: String, default: "INR" },
    orderId: { type: String },
    paymentId: { type: String },
    status: {
      type: String,
      enum: ["created", "paid", "failed"],
      default: "created",
    },
    expiryDate: { type: Date },
  },
  { timestamps: true, collection: "memberships" }
);

const Membership = mongoose.models.Membership || mongoose.model("Membership", membershipSchema);
export default Membership;
