import Mehendi from "./mehndi.schema.js";
import cloudinary from "../../../config/cloudinary.js";
import fs from "fs";
import mongoose from "mongoose";

// ✅ Transform MongoDB document to return `id`
const transformMehendi = (doc) => {
  if (!doc) return null;
  const obj = doc.toObject ? doc.toObject() : doc;

  return {
    id: obj._id?.toString() || obj.id,
    name: obj.name,
    studio: obj.studio,
    location: obj.location,
    projects: obj.projects,
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
const uploadToCloudinary = async (filePath, folder = "mehendi_images") => {
  const result = await cloudinary.uploader.upload(filePath, { folder });
  fs.unlinkSync(filePath); // delete local file
  return result.secure_url;
};

// ✅ Validate MongoDB ID
const isValidObjectId = (id) => mongoose.Types.ObjectId.isValid(id);

// ✅ Safe JSON parse
const safeParse = (data) => {
  if (!data) return [];
  if (typeof data !== "string") return data;
  try {
    return JSON.parse(data);
  } catch (e) {
    console.warn("Failed to parse JSON, returning empty array", e);
    return [];
  }
};

//
// CREATE Mehendi
//
export const createMehendi = async (req) => {
  const {
    name,
    studio,
    location,
    projects,
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
    galleryImages = Array.isArray(req.body.images) ? req.body.images : [req.body.images];
  }

  const newMehendi = new Mehendi({
    name,
    studio,
    location,
    projects,
    phone,
    detailname,
    image: mainImageUrl,
    images: galleryImages,
    about,
    pricing: safeParse(pricing),
    specializations: safeParse(specializations),
    reviews: safeParse(reviews),
  });

  const savedMehendi = await newMehendi.save();
  return { statusCode: 201, body: transformMehendi(savedMehendi) };
};

//
// GET All Mehendi Artists
//
export const getAllMehendi = async () => {
  const mehendiList = await Mehendi.find().sort({ createdAt: -1 });
  return { statusCode: 200, body: mehendiList.map(transformMehendi) };
};

//
// GET Mehendi by ID
//
export const getMehendiById = async (id) => {
  try {
    const mehendi = await Mehendi.findById(id);
    if (!mehendi) {
      return { statusCode: 404, body: { message: "Mehendi artist not found" } };
    }
    return { statusCode: 200, body: transformMehendi(mehendi) };
  } catch (error) {
    return { statusCode: 400, body: { message: error.message } };
  }
};

//
// UPDATE Mehendi
//
export const updateMehendi = async (req) => {
  const { id } = req.params;
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid Mehendi ID format" } };
  }

  const existing = await Mehendi.findById(id);
  if (!existing) {
    return { statusCode: 404, body: { success: false, message: "Mehendi artist not found" } };
  }

  const {
    name,
    studio,
    location,
    projects,
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
    updatedGallery = Array.isArray(req.body.images) ? req.body.images : [req.body.images];
  }

  const updatedMehendi = await Mehendi.findByIdAndUpdate(
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
      pricing: safeParse(pricing) || existing.pricing,
      specializations: safeParse(specializations) || existing.specializations,
      reviews: safeParse(reviews) || existing.reviews,
    },
    { new: true, runValidators: true }
  );

  return { statusCode: 200, body: transformMehendi(updatedMehendi) };
};

//
// DELETE Mehendi
//
export const deleteMehendi = async (id) => {
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid Mehendi ID format" } };
  }

  const mehendi = await Mehendi.findById(id);
  if (!mehendi) {
    return { statusCode: 404, body: { success: false, message: "Mehendi artist not found" } };
  }

  // Delete main image from Cloudinary
  if (mehendi.image) {
    const publicId = mehendi.image.split("/").pop().split(".")[0];
    await cloudinary.uploader.destroy(`mehendi_images/${publicId}`);
  }

  await Mehendi.findByIdAndDelete(id);
  return { statusCode: 200, body: { success: true, message: "Mehendi artist deleted successfully" } };
};
