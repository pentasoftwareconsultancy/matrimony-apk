import Jewellery from "./jewellery.schema.js";
import cloudinary from "../../../config/cloudinary.js";
import fs from "fs";
import mongoose from "mongoose";

// ✅ Transform _id → id
const transformJewellery = (doc) => {
  if (!doc) return null;
  const obj = doc.toObject ? doc.toObject() : doc;

  return {
    id: obj._id?.toString(),
    name: obj.name,
    company: obj.company,
    location: obj.location,
    phone: obj.phone,
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
const uploadToCloudinary = async (filePath, folder = "jewellery_images") => {
  const result = await cloudinary.uploader.upload(filePath, { folder });
  fs.unlinkSync(filePath);
  return result.secure_url;
};

// ✅ Validate ObjectId
const isValidObjectId = (id) => mongoose.Types.ObjectId.isValid(id);

//
// CREATE Jewellery
//
export const createJewellery = async (req) => {
  const { name, company, location, phone, project, about, pricing, specializations, reviews } = req.body;

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

  const newJewellery = new Jewellery({
    name,
    company,
    location,
    phone,
    project,
    about,
    image: mainImageUrl,
    images: galleryImages,
    pricing: typeof pricing === "string" ? JSON.parse(pricing) : pricing || [],
    specializations: typeof specializations === "string" ? JSON.parse(specializations) : specializations || [],
    reviews: typeof reviews === "string" ? JSON.parse(reviews) : reviews || [],
  });

  const savedJewellery = await newJewellery.save();
  return { statusCode: 201, body: transformJewellery(savedJewellery) };
};

//
// GET All Jewellery
//
export const getAllJewellery = async () => {
  const jewelleryItems = await Jewellery.find().sort({ createdAt: -1 });
  return { statusCode: 200, body: jewelleryItems.map(transformJewellery) };
};

//
// GET Jewellery by ID
//
export const getJewelleryById = async (id) => {
  try {
    const jewellery = await Jewellery.findById(id);
    if (!jewellery) {
      return { statusCode: 404, body: { message: "Jewellery not found" } };
    }
    return { statusCode: 200, body: transformJewellery(jewellery) };
  } catch (error) {
    return { statusCode: 400, body: { message: error.message } };
  }
};

//
// UPDATE Jewellery
//
export const updateJewellery = async (req) => {
  const { id } = req.params;
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid jewellery ID format" } };
  }

  const existing = await Jewellery.findById(id);
  if (!existing) {
    return { statusCode: 404, body: { success: false, message: "Jewellery not found" } };
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

  const updatedJewellery = await Jewellery.findByIdAndUpdate(
    id,
    {
      name: req.body.name,
      company: req.body.company,
      location: req.body.location,
      phone: req.body.phone,
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

  return { statusCode: 200, body: transformJewellery(updatedJewellery) };
};

//
// DELETE Jewellery
//
export const deleteJewellery = async (id) => {
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid jewellery ID format" } };
  }

  const jewellery = await Jewellery.findById(id);
  if (!jewellery) {
    return { statusCode: 404, body: { success: false, message: "Jewellery not found" } };
  }

  if (jewellery.image) {
    const publicId = jewellery.image.split("/").pop().split(".")[0];
    await cloudinary.uploader.destroy(`jewellery_images/${publicId}`);
  }

  await Jewellery.findByIdAndDelete(id);
  return { statusCode: 200, body: { success: true, message: "Jewellery deleted successfully" } };
};
