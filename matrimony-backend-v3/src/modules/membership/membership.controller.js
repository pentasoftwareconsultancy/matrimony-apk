// src/controllers/MembershipController.js
import {
  AppError,
  createMembershipOrder,
  verifyAndActivateMembership,
  getMembershipsForUser,
  getActiveMembershipStatus,
  getOtherMembersProfiles,
  getPremiumProfile,
} from "./membership.service.js";

// Create an order
export const createOrder = async (req, res) => {
  console.log("Incoming Body:", req.body);

  try {
    const { planType, amount } = req.body;
    const userId = req.user?.id; // from authMiddleware

    const { order, membershipId, key } = await createMembershipOrder(
      userId,
      planType,
      amount
    );

    return res.status(201).json({
      success: true,
      message: "Order created successfully",
      order,
      membershipId,
      key,
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    console.error("Create Order Error:", error);
    return res.status(500).json({
      success: false,
      message: "Server Error while creating order",
      error: error.message,
    });
  }
};

// Verify payment
export const verifyPayment = async (req, res) => {
  try {
    const { paymentId, membership } = await verifyAndActivateMembership(req.body);

    return res.json({
      success: true,
      message: "Payment verified successfully",
      paymentId,
      membership,
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    console.error("Verify Payment Error:", error);
    return res.status(500).json({
      success: false,
      message: "Server Error while verifying payment",
      error: error.message,
    });
  }
};

// Get memberships for logged-in user
export const getMyMemberships = async (req, res) => {
  try {
    const userId = req.user?.id; // from authMiddleware

    const memberships = await getMembershipsForUser(userId);

    return res.status(200).json({
      success: true,
      count: memberships.length,
      memberships,
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    console.error("Get My Memberships Error:", error);
    return res.status(500).json({
      success: false,
      message: "Server error while fetching your memberships",
      error: error.message,
    });
  }
};

export const checkActiveMembership = async (req, res) => {
  try {
    const { userId } = req.body;
    const status = await getActiveMembershipStatus(userId);
    return res.json(status);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ active: false, message: "Server error" });
  }
};

export const getOtherMembershipsWithProfiles = async (req, res) => {
  try {
    const userId = req.user?.id;
    const profiles = await getOtherMembersProfiles(userId);

    return res.status(200).json({
      success: true,
      count: profiles.length,
      profiles,
    });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    console.error("Get Other Memberships With Profiles Error:", error);
    return res.status(500).json({
      success: false,
      message: "Server error while fetching profiles",
      error: error.message,
    });
  }
};

export const getPremiumProfileById = async (req, res) => {
  try {
    const { id } = req.params;
    const profile = await getPremiumProfile(id);
    res.json({ success: true, profile });
  } catch (error) {
    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    console.error("Get Premium Profile Error:", error);
    res.status(500).json({ success: false, message: "Server error", error: error.message });
  }
};