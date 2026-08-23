 import Decoration from "./djmusic.schema.js";
 import cloudinary from "../../../config/cloudinary.js";
 import fs from "fs";
 import mongoose from "mongoose";

const transformDJMusic = (doc) => {
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

export const createDJMusic = async (req) => {
  const {
    name,
    company,
    location,
    project,
    about,
    phone,
    pricing,
    specializations,
    reviews,
  } = req.body;

  if (!name) {
    return {
      statusCode: 400,
      success: false,
      message: "Name is required",
    };
  }

  let mainImage = null;

  if (req.files?.image?.[0]) {
    mainImage = await uploadToCloudinary(
      req.files.image[0].path,
      "djmusic_images"
    );
  } else if (req.body.image) {
    mainImage = req.body.image;
  }

  let gallery = [];

  if (req.files?.images) {
    for (const file of req.files.images) {
      gallery.push(
        await uploadToCloudinary(file.path, "djmusic_images")
      );
    }
  } else if (req.body.images) {
    gallery = Array.isArray(req.body.images)
      ? req.body.images
      : [req.body.images];
  }

  const dj = await DJMusic.create({
    name,
    company,
    location,
    phone,
    project,
    about,
    image: mainImage,
    images: gallery,
    pricing:
      typeof pricing === "string"
        ? JSON.parse(pricing)
        : pricing || [],
    specializations:
      typeof specializations === "string"
        ? JSON.parse(specializations)
        : specializations || [],
    reviews:
      typeof reviews === "string"
        ? JSON.parse(reviews)
        : reviews || [],
  });

  return {
    statusCode: 201,
    success: true,
    message: "DJ Music created successfully.",
    data: transformDJMusic(dj),
  };
};

export const getAllDJMusic = async () => {
  const djs = await DJMusic.find().sort({ createdAt: -1 });

  return {
    statusCode: 200,
    success: true,
    data: djs.map(transformDJMusic),
  };
};

export const getDJMusicById = async (id) => {
  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      success: false,
      message: "Invalid DJ Music ID",
    };
  }

  const dj = await DJMusic.findById(id);

  if (!dj) {
    return {
      statusCode: 404,
      success: false,
      message: "DJ Music not found",
    };
  }

  return {
    statusCode: 200,
    success: true,
    data: transformDJMusic(dj),
  };
};

export const updateDJMusic = async (req) => {
  const { id } = req.params;

  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      success: false,
      message: "Invalid DJ Music ID",
    };
  }

  const existing = await DJMusic.findById(id);

  if (!existing) {
    return {
      statusCode: 404,
      success: false,
      message: "DJ Music not found",
    };
  }

  let mainImage = existing.image;

  if (req.files?.image?.[0]) {
    mainImage = await uploadToCloudinary(
      req.files.image[0].path,
      "djmusic_images"
    );
  } else if (req.body.image) {
    mainImage = req.body.image;
  }

  let gallery = existing.images || [];

  if (req.files?.images) {
    gallery = [];

    for (const file of req.files.images) {
      gallery.push(
        await uploadToCloudinary(file.path, "djmusic_images")
      );
    }
  } else if (req.body.images) {
    gallery = Array.isArray(req.body.images)
      ? req.body.images
      : [req.body.images];
  }

  const updated = await DJMusic.findByIdAndUpdate(
    id,
    {
      name: req.body.name,
      company: req.body.company,
      location: req.body.location,
      phone: req.body.phone,
      project: req.body.project,
      about: req.body.about,
      image: mainImage,
      images: gallery,
      pricing: req.body.pricing
        ? typeof req.body.pricing === "string"
          ? JSON.parse(req.body.pricing)
          : req.body.pricing
        : existing.pricing,
      specializations: req.body.specializations
        ? typeof req.body.specializations === "string"
          ? JSON.parse(req.body.specializations)
          : req.body.specializations
        : existing.specializations,
      reviews: req.body.reviews
        ? typeof req.body.reviews === "string"
          ? JSON.parse(req.body.reviews)
          : req.body.reviews
        : existing.reviews,
    },
    {
      new: true,
      runValidators: true,
    }
  );

  return {
    statusCode: 200,
    success: true,
    message: "DJ Music updated successfully.",
    data: transformDJMusic(updated),
  };
};

export const deleteDJMusic = async (id) => {
  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      success: false,
      message: "Invalid DJ Music ID",
    };
  }

  const dj = await DJMusic.findById(id);

  if (!dj) {
    return {
      statusCode: 404,
      success: false,
      message: "DJ Music not found",
    };
  }

  if (dj.image) {
    const publicId = dj.image.split("/").pop().split(".")[0];
    await cloudinary.uploader.destroy(`djmusic_images/${publicId}`);
  }

  await DJMusic.findByIdAndDelete(id);

  return {
    statusCode: 200,
    success: true,
    message: "DJ Music deleted successfully.",
  };
};