import mongoose from "mongoose";
import Matrimony from "./bridegroom.schema.js";

// Helper: validate MongoDB ObjectId
const isValidObjectId = (id) => mongoose.Types.ObjectId.isValid(id);

// Fetch opposite-gender users from same village (excluding logged-in user)
export const getNearmeProfiles = async (userId) => {
  console.log("Received userId:", userId);

  if (!isValidObjectId(userId)) {
    console.warn("Invalid user ID format:", userId);
    return {
      statusCode: 400,
      body: { success: false, message: "Invalid user ID format", receivedId: userId },
    };
  }

  // Fetch current user
  const currentUser = await Matrimony.findById(userId);
  console.log("Current user fetched:", currentUser ? currentUser._id : null);

  if (!currentUser) {
    console.warn("User not found:", userId);
    return { statusCode: 404, body: { success: false, message: "User not found" } };
  }

  // Determine opposite gender
  const oppositeGender =
    currentUser.personalDetail?.gender === "Groom" ? "Bride" : "Groom";

  // Get current user's village
  const userVillage = currentUser.userRegistration?.village;
  if (!userVillage) {
    console.warn("Current user has no village set");
    return {
      statusCode: 400,
      body: { success: false, message: "User does not have a village set" },
    };
  }

  // Fetch users with opposite gender + same village (excluding current user)
  const users = await Matrimony.find({
    _id: { $ne: userId },
    "personalDetail.gender": oppositeGender,
    "userRegistration.village": userVillage,
  }).select("-userRegistration.confirmPassword");

  console.log(
    `Found ${users.length} ${oppositeGender}(s) in village ${userVillage}`
  );

  return {
    statusCode: 200,
    body: {
      success: true,
      message: "Filtered users fetched successfully",
      count: users.length,
      village: userVillage,
      gender: oppositeGender,
      data: users,
    },
  };
};

// Fetch single profile by ID
export const getSingleProfile = async (id) => {
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid user ID format" } };
  }

  const user = await Matrimony.findById(id).select(
    "-userRegistration.confirmPassword"
  );

  if (!user) {
    return { statusCode: 404, body: { success: false, message: "Profile not found" } };
  }

  return {
    statusCode: 200,
    body: { success: true, message: "Profile fetched successfully", data: user },
  };
};
