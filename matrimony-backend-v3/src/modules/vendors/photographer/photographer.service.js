import Photographer from "./photographer.schema.js";
import cloudinary from "../../../config/cloudinary.js";
import fs from "fs";
import mongoose from "mongoose";

// Helper: Transform MongoDB document to use 'id' instead of '_id'
const transformPhotographer = (doc) => {
  if (!doc) return null;
  const obj = doc.toObject ? doc.toObject() : doc;

  const transformed = {
    id: obj._id ? obj._id.toString() : obj.id,
    ...obj
  };

  delete transformed._id;
  delete transformed.__v;

  return transformed;
};

// Helper: upload file to Cloudinary
const uploadToCloudinary = async (filePath, folder = "photographer_images") => {
  const result = await cloudinary.uploader.upload(filePath, { folder });
  fs.unlinkSync(filePath);
  return result.secure_url;
};

// Validate MongoDB ID
const isValidObjectId = (id) => mongoose.Types.ObjectId.isValid(id);

// ✅ Create Photographer
export const createPhotographer = async (req) => {
  const { name, studio, location, projects, phone, detailname, about, pricing, specializations, reviews } = req.body;

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

  // Handle multiple images
  let galleryImages = [];
  if (req.files?.images) {
    for (const file of req.files.images) {
      const url = await uploadToCloudinary(file.path);
      galleryImages.push(url);
    }
  } else if (req.body.images) {
    galleryImages = Array.isArray(req.body.images) ? req.body.images : [req.body.images];
  }

  // Parse pricing
  let parsedPricing = [];
  if (pricing) {
    try {
      parsedPricing = typeof pricing === "string" ? JSON.parse(pricing) : pricing;
    } catch {
      return { statusCode: 400, body: { success: false, message: "Invalid pricing format" } };
    }
  }

  // Parse specializations
  let parsedSpecializations = [];
  if (specializations) {
    try {
      parsedSpecializations = typeof specializations === "string" ? JSON.parse(specializations) : specializations;
    } catch {
      return { statusCode: 400, body: { success: false, message: "Invalid specializations format" } };
    }
  }

  // Parse reviews
  let parsedReviews = [];
  if (reviews) {
    try {
      parsedReviews = typeof reviews === "string" ? JSON.parse(reviews) : reviews;
    } catch {
      return { statusCode: 400, body: { success: false, message: "Invalid reviews format" } };
    }
  }

  const newPhotographer = new Photographer({
    name,
    studio,
    location,
    projects,
    phone,
    detailname,
    image: mainImageUrl,
    images: galleryImages,
    about,
    pricing: parsedPricing,
    specializations: parsedSpecializations,
    reviews: parsedReviews
  });

  const savedPhotographer = await newPhotographer.save();
  return { statusCode: 201, body: transformPhotographer(savedPhotographer) };
};

// ✅ Get All Photographers
export const getAllPhotographers = async () => {
  const photographers = await Photographer.find().sort({ createdAt: -1 });
  return { statusCode: 200, body: photographers.map(transformPhotographer) };
};

// ✅ Get Photographer by ID
export const getPhotographerById = async (id) => {
  try {
    const photographer = await Photographer.findById(id);
    if (!photographer) {
      return { statusCode: 404, body: { message: "Photographer not found" } };
    }
    return { statusCode: 200, body: transformPhotographer(photographer) };
  } catch (error) {
    return { statusCode: 400, body: { message: error.message } };
  }
};

// ✅ Update Photographer
export const updatePhotographer = async (req) => {
  const { id } = req.params;
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid photographer ID format" } };
  }

  const existing = await Photographer.findById(id);
  if (!existing) {
    return { statusCode: 404, body: { success: false, message: "Photographer not found" } };
  }

  const { name, studio, location, projects, phone, detailname, about, pricing, specializations, reviews } = req.body;

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
    updatedGallery = Array.isArray(req.body.images) ? req.body.images : [req.body.images];
  }

  // Parse pricing
  let parsedPricing = existing.pricing;
  if (pricing) {
    try {
      parsedPricing = typeof pricing === "string" ? JSON.parse(pricing) : pricing;
    } catch {
      return { statusCode: 400, body: { success: false, message: "Invalid pricing format" } };
    }
  }

  // Parse specializations
  let parsedSpecializations = existing.specializations;
  if (specializations) {
    try {
      parsedSpecializations = typeof specializations === "string" ? JSON.parse(specializations) : specializations;
    } catch {
      return { statusCode: 400, body: { success: false, message: "Invalid specializations format" } };
    }
  }

  // Parse reviews
  let parsedReviews = existing.reviews;
  if (reviews) {
    try {
      parsedReviews = typeof reviews === "string" ? JSON.parse(reviews) : reviews;
    } catch {
      return { statusCode: 400, body: { success: false, message: "Invalid reviews format" } };
    }
  }

  const updatedPhotographer = await Photographer.findByIdAndUpdate(
    id,
    {
      name,
      studio,
      location,
      projects,
      phone,
      detailname,
      image: updatedMainImage,
      images: updatedGallery,
      about,
      pricing: parsedPricing,
      specializations: parsedSpecializations,
      reviews: parsedReviews
    },
    { new: true, runValidators: true }
  );

  return { statusCode: 200, body: transformPhotographer(updatedPhotographer) };
};

// ✅ Delete Photographer
export const deletePhotographer = async (id) => {
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid photographer ID format" } };
  }

  const photographer = await Photographer.findById(id);
  if (!photographer) {
    return { statusCode: 404, body: { success: false, message: "Photographer not found" } };
  }

  // Delete main image from Cloudinary
  if (photographer.image) {
    const publicId = photographer.image.split("/").pop().split(".")[0];
    await cloudinary.uploader.destroy(`photographer_images/${publicId}`);
  }

  await Photographer.findByIdAndDelete(id);
  return { statusCode: 200, body: { success: true, message: "Photographer deleted successfully" } };
};
