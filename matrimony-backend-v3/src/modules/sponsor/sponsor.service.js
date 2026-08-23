import Sponsor from "./sponsor.schema.js";
import cloudinary from "../../config/cloudinary.js";
import fs from "fs";
import mongoose from "mongoose";

const uploadToCloudinary = async (filePath, folder = "sponsors") => {
  try {
    const result = await cloudinary.uploader.upload(filePath, { folder });
    fs.unlinkSync(filePath);
    return result.secure_url;
  } catch (err) {
    console.error("Cloudinary upload error:", err);
    throw new Error("Failed to upload image");
  }
};

const isValidObjectId = (id) => mongoose.Types.ObjectId.isValid(id);

export const createSponsor = async (req) => {
  const { name, description, links } = req.body;

  if (!name) {
    const err = new Error("Name is required");
    err.status = 400;
    throw err;
  }

  let src = req.files?.src?.length
    ? await uploadToCloudinary(req.files.src[0].path)
    : req.body.src;

  let images = req.files?.images?.length
    ? await Promise.all(
        req.files.images.map((file) => uploadToCloudinary(file.path))
      )
    : req.body.images
    ? Array.isArray(req.body.images)
      ? req.body.images
      : [req.body.images]
    : [];

  const parsedLinks = links
    ? typeof links === "string"
      ? JSON.parse(links)
      : links
    : [];

  const sponsor = new Sponsor({
    name,
    description,
    src,
    images,
    links: parsedLinks,
  });

  return await sponsor.save();
};

export const getAllSponsors = async () => {
  return await Sponsor.find().sort({ createdAt: -1 });
};

export const getSponsorById = async (id) => {
  if (!isValidObjectId(id)) {
    const err = new Error("Invalid sponsor ID");
    err.status = 400;
    throw err;
  }

  const sponsor = await Sponsor.findById(id);

  if (!sponsor) {
    const err = new Error("Sponsor not found");
    err.status = 404;
    throw err;
  }

  return sponsor;
};

export const updateSponsor = async (req) => {
  const { id } = req.params;

  if (!isValidObjectId(id)) {
    const err = new Error("Invalid sponsor ID");
    err.status = 400;
    throw err;
  }

  const sponsor = await Sponsor.findById(id);

  if (!sponsor) {
    const err = new Error("Sponsor not found");
    err.status = 404;
    throw err;
  }

  const { name, description, links } = req.body;

  let updatedSrc = req.files?.src?.length
    ? await uploadToCloudinary(req.files.src[0].path)
    : req.body.src || sponsor.src;

  let updatedImages = req.files?.images?.length
    ? await Promise.all(
        req.files.images.map((file) => uploadToCloudinary(file.path))
      )
    : req.body.images
    ? Array.isArray(req.body.images)
      ? req.body.images
      : [req.body.images]
    : sponsor.images;

  const parsedLinks = links
    ? typeof links === "string"
      ? JSON.parse(links)
      : links
    : sponsor.links;

  return await Sponsor.findByIdAndUpdate(
    id,
    {
      name,
      description,
      src: updatedSrc,
      images: updatedImages,
      links: parsedLinks,
    },
    {
      new: true,
      runValidators: true,
    }
  );
};

export const deleteSponsor = async (id) => {
  if (!isValidObjectId(id)) {
    const err = new Error("Invalid sponsor ID");
    err.status = 400;
    throw err;
  }

  const sponsor = await Sponsor.findById(id);

  if (!sponsor) {
    const err = new Error("Sponsor not found");
    err.status = 404;
    throw err;
  }

  if (sponsor.src) {
    const publicId = sponsor.src.split("/").pop().split(".")[0];
    try {
      await cloudinary.uploader.destroy(`sponsors/${publicId}`);
    } catch (err) {
      console.error(err);
    }
  }

  if (sponsor.images?.length) {
    for (const img of sponsor.images) {
      const publicId = img.split("/").pop().split(".")[0];
      try {
        await cloudinary.uploader.destroy(`sponsors/${publicId}`);
      } catch (err) {
        console.error(err);
      }
    }
  }

  await Sponsor.findByIdAndDelete(id);

  return {
    success: true,
    message: "Sponsor deleted successfully",
  };
};