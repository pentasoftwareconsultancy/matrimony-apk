import Lighting from "./lighting.schema.js";
import cloudinary from "../../../config/cloudinary.js";
import fs from "fs";
import mongoose from "mongoose";

// ✅ Always transform _id → id
const transformLighting = (doc) => {
  if (!doc) return null;
  const obj = doc.toObject ? doc.toObject() : doc;

  return {
    id: obj._id?.toString(),   // 🔑 Always return id
    name: obj.name,
    company: obj.company,
    location: obj.location,
    project: obj.project,
    about: obj.about,
    image: obj.image,
    images: obj.images,
    specializations: obj.specializations,
    pricing: obj.pricing,
    reviews: obj.reviews,
    createdAt: obj.createdAt,
    updatedAt: obj.updatedAt,
  };
};

// ✅ Upload to Cloudinary
const uploadToCloudinary = async (filePath, folder = "lighting_images") => {
  const result = await cloudinary.uploader.upload(filePath, { folder });
  fs.unlinkSync(filePath);
  return result.secure_url;
};

// ✅ Validate ObjectId
const isValidObjectId = (id) => mongoose.Types.ObjectId.isValid(id);

//
// CREATE Lighting
//
export const createLighting = async (req) => {
  const { name, company, location, project, about, pricing, specializations, reviews } = req.body;

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
    galleryImages = Array.isArray(req.body.images) ? req.body.images : [req.body.images];
  }

  const newLighting = new Lighting({
    name,
    company,
    location,
    project,
    about,
    image: mainImageUrl,
    images: galleryImages,
    pricing: typeof pricing === "string" ? JSON.parse(pricing) : pricing || [],
    specializations: typeof specializations === "string" ? JSON.parse(specializations) : specializations || [],
    reviews: typeof reviews === "string" ? JSON.parse(reviews) : reviews || [],
  });

  const savedLighting = await newLighting.save();
  return { statusCode: 201, body: transformLighting(savedLighting) };
};

//
// GET All Lightings
//
export const getAllLightings = async () => {
  const lightings = await Lighting.find().sort({ createdAt: -1 });
  return { statusCode: 200, body: lightings.map(transformLighting) };
};

//
// GET Lighting by ID
//
export const getLightingById = async (id) => {
  try {
    const lighting = await Lighting.findById(id);
    if (!lighting) {
      return { statusCode: 404, body: { message: "Lighting not found" } };
    }
    return { statusCode: 200, body: transformLighting(lighting) };
  } catch (error) {
    return { statusCode: 400, body: { message: error.message } };
  }
};

//
// UPDATE Lighting
//
export const updateLighting = async (req) => {
  const { id } = req.params;
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid lighting ID format" } };
  }

  const existing = await Lighting.findById(id);
  if (!existing) {
    return { statusCode: 404, body: { success: false, message: "Lighting not found" } };
  }

  let updatedMainImage = existing.image;
  if (req.files?.image?.[0]) {
    updatedMainImage = await uploadToCloudinary(req.files.image[0].path);
  } else if (req.body.image) {
    updatedMainImage = req.body.image;
  }

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

  const updatedLighting = await Lighting.findByIdAndUpdate(
    id,
    {
      name: req.body.name,
      company: req.body.company,
      location: req.body.location,
      project: req.body.project,
      about: req.body.about,
      image: updatedMainImage,
      images: updatedGallery,
      pricing: req.body.pricing ? (typeof req.body.pricing === "string" ? JSON.parse(req.body.pricing) : req.body.pricing) : existing.pricing,
      specializations: req.body.specializations ? (typeof req.body.specializations === "string" ? JSON.parse(req.body.specializations) : req.body.specializations) : existing.specializations,
      reviews: req.body.reviews ? (typeof req.body.reviews === "string" ? JSON.parse(req.body.reviews) : req.body.reviews) : existing.reviews,
    },
    { new: true, runValidators: true }
  );

  return { statusCode: 200, body: transformLighting(updatedLighting) };
};

//
// DELETE Lighting
//
export const deleteLighting = async (id) => {
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid lighting ID format" } };
  }

  const lighting = await Lighting.findById(id);
  if (!lighting) {
    return { statusCode: 404, body: { success: false, message: "Lighting not found" } };
  }

  if (lighting.image) {
    const publicId = lighting.image.split("/").pop().split(".")[0];
    await cloudinary.uploader.destroy(`lighting_images/${publicId}`);
  }

  await Lighting.findByIdAndDelete(id);
  return { statusCode: 200, body: { success: true, message: "Lighting deleted successfully" } };
};
