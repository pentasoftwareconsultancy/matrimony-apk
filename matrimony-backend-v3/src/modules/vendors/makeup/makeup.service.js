import Makeup from "./makeup.schema.js";
import cloudinary from "../../../config/cloudinary.js";
import fs from "fs";
import mongoose from "mongoose";

// ✅ Transform MongoDB document to return `id`
const transformMakeup = (doc) => {
  if (!doc) return null;
  const obj = doc.toObject ? doc.toObject() : doc;

  return {
    id: obj._id?.toString() || obj.id, // always include id
    name: obj.name,
    studio: obj.studio,
    location: obj.location,
    project: obj.project,
    phone: obj.phone,
    detailname: obj.detailname,
    image: obj.image,
    images: obj.images,
    about: obj.about,
    pricing: obj.pricing,
    specializations: obj.specializations,
    reviews: obj.reviews,
    createdAt: obj.createdAt,
    updatedAt: obj.updatedAt,
  };
};

// ✅ Upload file to Cloudinary
const uploadToCloudinary = async (filePath, folder = "makeup_images") => {
  const result = await cloudinary.uploader.upload(filePath, { folder });
  fs.unlinkSync(filePath); // delete local file
  return result.secure_url;
};

// ✅ Validate MongoDB ID
const isValidObjectId = (id) => mongoose.Types.ObjectId.isValid(id);

//
// CREATE Makeup
//
export const createMakeup = async (req) => {
  const {
    name,
    studio,
    location,
    project,
    phone,
    detailname,
    about,
    pricing,
    specializations,
    reviews,
  } = req.body;

  if (!name) {
    return { statusCode: 400, body: { success: false, message: "Name is required" } };
  }

  // Handle main image
  let mainImageUrl = null;
  if (req.files?.image?.[0]) {
    mainImageUrl = await uploadToCloudinary(req.files.image[0].path);
  } else if (req.body.image) {
    mainImageUrl = req.body.image;
  }

  // Handle gallery images
  let galleryImages = [];
  if (req.files?.images) {
    for (const file of req.files.images) {
      const url = await uploadToCloudinary(file.path);
      galleryImages.push(url);
    }
  } else if (req.body.images) {
    galleryImages = Array.isArray(req.body.images)
      ? req.body.images
      : [req.body.images];
  }

  // Parse pricing, specializations, reviews
  const parsedPricing =
    typeof pricing === "string" ? JSON.parse(pricing) : pricing || [];

  const parsedSpecializations =
    typeof specializations === "string"
      ? JSON.parse(specializations)
      : specializations || [];

  const parsedReviews =
    typeof reviews === "string" ? JSON.parse(reviews) : reviews || [];

  const newMakeup = new Makeup({
    name,
    studio,
    location,
    project,
    phone,
    detailname,
    image: mainImageUrl,
    images: galleryImages,
    about,
    pricing: parsedPricing,
    specializations: parsedSpecializations,
    reviews: parsedReviews,
  });

  const savedMakeup = await newMakeup.save();
  return { statusCode: 201, body: transformMakeup(savedMakeup) };
};

//
// GET All Makeup
//
export const getAllMakeup = async () => {
  const makeups = await Makeup.find().sort({ createdAt: -1 });
  return { statusCode: 200, body: makeups.map(transformMakeup) };
};

//
// GET Makeup by ID
//
export const getMakeupById = async (id) => {
  try {
    const makeup = await Makeup.findById(id);
    if (!makeup) {
      return { statusCode: 404, body: { message: "Makeup not found" } };
    }
    return { statusCode: 200, body: transformMakeup(makeup) };
  } catch (error) {
    return { statusCode: 400, body: { message: error.message } };
  }
};

//
// UPDATE Makeup
//
export const updateMakeup = async (req) => {
  const { id } = req.params;
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid makeup ID format" } };
  }

  const existing = await Makeup.findById(id);
  if (!existing) {
    return { statusCode: 404, body: { success: false, message: "Makeup not found" } };
  }

  const {
    name,
    studio,
    location,
    project,
    phone,
    detailname,
    about,
    pricing,
    specializations,
    reviews,
  } = req.body;

  // Update main image
  let updatedMainImage = existing.image;
  if (req.files?.image?.[0]) {
    updatedMainImage = await uploadToCloudinary(req.files.image[0].path);
  } else if (req.body.image) {
    updatedMainImage = req.body.image;
  }

  // Update gallery images
  let updatedGallery = existing.images || [];
  if (req.files?.images) {
    updatedGallery = [];
    for (const file of req.files.images) {
      const url = await uploadToCloudinary(file.path);
      updatedGallery.push(url);
    }
  } else if (req.body.images) {
    updatedGallery = Array.isArray(req.body.images)
      ? req.body.images
      : [req.body.images];
  }

  const parsedPricing =
    pricing ? (typeof pricing === "string" ? JSON.parse(pricing) : pricing) : existing.pricing;

  const parsedSpecializations =
    specializations
      ? (typeof specializations === "string"
          ? JSON.parse(specializations)
          : specializations)
      : existing.specializations;

  const parsedReviews =
    reviews
      ? (typeof reviews === "string" ? JSON.parse(reviews) : reviews)
      : existing.reviews;

  const updatedMakeup = await Makeup.findByIdAndUpdate(
    id,
    {
      name,
      studio,
      location,
      project,
      phone,
      detailname,
      image: updatedMainImage,
      images: updatedGallery,
      about,
      pricing: parsedPricing,
      specializations: parsedSpecializations,
      reviews: parsedReviews,
    },
    { new: true, runValidators: true }
  );

  return { statusCode: 200, body: transformMakeup(updatedMakeup) };
};

//
// DELETE Makeup
//
export const deleteMakeup = async (id) => {
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid makeup ID format" } };
  }

  const makeup = await Makeup.findById(id);
  if (!makeup) {
    return { statusCode: 404, body: { success: false, message: "Makeup not found" } };
  }

  // Delete main image from Cloudinary
  if (makeup.image) {
    const publicId = makeup.image.split("/").pop().split(".")[0];
    await cloudinary.uploader.destroy(`makeup_images/${publicId}`);
  }

  await Makeup.findByIdAndDelete(id);
  return { statusCode: 200, body: { success: true, message: "Makeup deleted successfully" } };
};
