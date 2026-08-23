// src/services/membershipService.js
import Razorpay from "razorpay";
import crypto from "crypto";
import mongoose from "mongoose";
import Membership from "./membership.schema.js";
import BrideGroom from "../brideGroom/bridegroom.schema.js";

// Razorpay instance
const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID,
  key_secret: process.env.RAZORPAY_SECRET,
});

// Generic service-layer error carrying an HTTP status code
export class AppError extends Error {
  constructor(status, message) {
    super(message);
    this.name = "AppError";
    this.status = status;
  }
}

const THIRTY_DAYS_MS = 30 * 24 * 60 * 60 * 1000;

/* ------------------------------------------------------------------
   ORDER CREATION
-------------------------------------------------------------------*/

// Find a user's currently active (paid, unexpired) membership, if any
export const findActiveMembership = async (userId) => {
  return Membership.findOne({
    userId,
    status: "paid",
    expiryDate: { $gt: new Date() },
  });
};

// Creates a Razorpay order + a "created" membership record for it.
// Throws AppError(400, ...) if the user already has an active membership.
export const createMembershipOrder = async (userId, planType, amount) => {
  if (!planType || !amount) {
    throw new AppError(400, "Plan type and amount are required");
  }

  const activeMembership = await findActiveMembership(userId);
  console.log("Active Membership:", activeMembership);
  if (activeMembership) {
    throw new AppError(
      400,
      `You already have an active membership (${
        activeMembership.planType
      }) which expires on ${activeMembership.expiryDate.toDateString()}.`
    );
  }

  const options = {
    amount: amount * 100, // paise
    currency: "INR",
    receipt: `rcpt_${Date.now()}`,
  };

  const order = await razorpay.orders.create(options);

  const expiryDate = new Date(Date.now() + THIRTY_DAYS_MS);

  const membership = new Membership({
    userId,
    planType,
    amount,
    currency: "INR",
    orderId: order.id,
    status: "created",
    expiryDate,
  });

  await membership.save();

  return {
    order,
    membershipId: membership._id,
    key: process.env.RAZORPAY_KEY_ID,
  };
};

/* ------------------------------------------------------------------
   PAYMENT VERIFICATION
-------------------------------------------------------------------*/

// Verifies the Razorpay signature and, if valid, marks the matching
// membership as paid. Throws AppError(400, ...) on missing fields or an
// invalid signature.
export const verifyAndActivateMembership = async ({
  razorpay_order_id,
  razorpay_payment_id,
  razorpay_signature,
}) => {
  if (!razorpay_order_id || !razorpay_payment_id || !razorpay_signature) {
    throw new AppError(400, "Missing payment details");
  }

  const sign = razorpay_order_id + "|" + razorpay_payment_id;
  const expectedSign = crypto
    .createHmac("sha256", process.env.RAZORPAY_SECRET)
    .update(sign.toString())
    .digest("hex");

  if (expectedSign !== razorpay_signature) {
    throw new AppError(400, "Invalid signature, payment verification failed");
  }

  const membership = await Membership.findOne({
    orderId: razorpay_order_id,
  }).populate("userId", "fullName email phoneNumber");

  if (membership) {
    membership.status = "paid";
    membership.paymentId = razorpay_payment_id;
    membership.startDate = new Date();
    membership.expiryDate = new Date(Date.now() + THIRTY_DAYS_MS);
    await membership.save();
  }

  return {
    paymentId: razorpay_payment_id,
    membership: membership
      ? {
          id: membership._id,
          userId: membership.userId?._id,
          email: membership.userId?.email,
          planType: membership.planType,
          amount: membership.amount,
          status: membership.status,
          startDate: membership.startDate,
          expiryDate: membership.expiryDate,
        }
      : null,
  };
};

/* ------------------------------------------------------------------
   READS
-------------------------------------------------------------------*/

// All memberships for a given user, most recent first
export const getMembershipsForUser = async (userId) => {
  if (!userId) {
    throw new AppError(400, "User ID not found in request");
  }

  return Membership.find({ userId })
    .populate("userId", "fullName email phoneNumber")
    .sort({ createdAt: -1 });
};

// Simple active/inactive check, used by checkActiveMembership
export const getActiveMembershipStatus = async (userId) => {
  const active = await findActiveMembership(userId);

  if (!active) return { active: false };

  return {
    active: true,
    planType: active.planType,
    expiryDate: active.expiryDate,
  };
};

// Plan tiers a user's current paid membership entitles them to browse
const PLAN_HIERARCHY = {
  silver: ["Silver"],
  gold: ["Silver", "Gold"],
  platinum: ["Silver", "Gold", "Platinum"],
};

// Finds profiles of the opposite gender held by other users whose
// membership plan is within the requesting user's allowed tier.
// Throws AppError(400/403, ...) if the user has no active paid membership.
export const getOtherMembersProfiles = async (userId) => {
  if (!userId) {
    throw new AppError(400, "User ID not found in request");
  }

  const myMembership = await Membership.findOne({
    userId,
    status: "paid",
    planType: { $ne: "free" },
    expiryDate: { $gt: new Date() },
  });

  if (!myMembership) {
    throw new AppError(403, "You don't have an active paid membership");
  }

  const loggedInUser = await BrideGroom.findById(userId).lean();
  const myGender = loggedInUser?.personalDetail?.gender;

  const allowedPlans = PLAN_HIERARCHY[myMembership.planType.toLowerCase()] || [];

  const memberships = await Membership.find({
    userId: { $ne: userId },
    planType: { $in: allowedPlans, $ne: "free" },
    status: "paid",
    expiryDate: { $gt: new Date() },
  }).sort({ createdAt: -1 });

  const userIds = memberships.map(
    (m) => new mongoose.Types.ObjectId(m.userId._id)
  );

  console.log("User IDs to fetch:", userIds);

  const oppositeGender = myGender === "Bride" ? "Groom" : "Bride";

  const profiles = await BrideGroom.find({
    _id: { $in: userIds },
    "personalDetail.gender": oppositeGender,
  })
    .select("-userRegistration.password -userRegistration.confirmPassword -__v")
    .lean();

  return profiles;
};

// Fetch a single premium profile by id
export const getPremiumProfile = async (id) => {
  const profile = await BrideGroom.findById(id)
    .select("-userRegistration.password -userRegistration.confirmPassword")
    .lean();

  if (!profile) {
    throw new AppError(404, "Profile not found");
  }

  return profile;
};