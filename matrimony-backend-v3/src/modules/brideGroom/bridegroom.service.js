import Matrimony from "./bridegroom.schema.js";
import cloudinary from "../../config/cloudinary.js";

export const getProfilessService = async () => {
  const users = await Matrimony.find().select("-userRegistration.password");

  if (!users || users.length === 0) {
    throw new Error("User not found");
  }

  return users;
};

export const getProfilesService = async (userId) => {
  const currentUser = await Matrimony.findById(userId).select(
    "-userRegistration.password"
  );

  if (!currentUser) {
    throw new Error("User not found");
  }

  // Your filtering logic can be added here later
  const users = [];

  return {
    count: users.length,
    users,
  };
};

export const getProfileByIdService = async (id) => {
  const profile = await Matrimony.findById(id);

  if (!profile) {
    throw new Error("Profile not found");
  }

  return profile;
};

export const deleteProfileByIdService = async (id) => {
  const profile = await Matrimony.findById(id);

  if (!profile) {
    throw new Error("Profile not found");
  }

  const imageFields = [
    "aadhaarFrontphoto",
    "aadhaarBackphoto",
    "panFrontphoto",
    "panBackphoto",
    "passportFrontphoto",
    "passportBackphoto",
    "educationCertificate",
    "castecertificate",
    "highestEducationalDoc",
    "photoCloseup",
    "photoFull",
    "familyPhoto",
  ];

  for (const field of imageFields) {
    if (profile[field]?.public_id) {
      await cloudinary.uploader.destroy(profile[field].public_id);
    }
  }

  await Matrimony.findByIdAndDelete(id);

  return {
    success: true,
    message: "Profile and all images deleted successfully",
  };
};