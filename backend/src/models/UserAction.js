import mongoose from "mongoose";

const userActionSchema = new mongoose.Schema(
  {
    fromUser: { type: mongoose.Schema.Types.ObjectId, ref: "Matrimony", required: true },
    toUser: { type: mongoose.Schema.Types.ObjectId, ref: "Matrimony", required: true },
    actionType: { type: String, enum: ["interest", "ignore", "shortlist", "report"], required: true },
    active: { type: Boolean, default: true },
    reportReason: { type: String },
    reportNote: { type: String },
    createdAt: { type: Date, default: Date.now },
  },
  { collection: "useractions" }
);

userActionSchema.index({ fromUser: 1, toUser: 1, actionType: 1 }, { unique: true });

const UserAction = mongoose.models.UserAction || mongoose.model("UserAction", userActionSchema);
export default UserAction;
