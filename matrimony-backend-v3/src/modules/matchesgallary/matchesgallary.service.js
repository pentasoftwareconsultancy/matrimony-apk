import MatchesGallery from "./matchesgallary.schema.js";
import cloudinary from "../../config/cloudinary.js";
import fs from "fs";
import mongoose from "mongoose";

// ✅ Transform MongoDB document to return `id`
const transformGallery = (doc) => {
  if (!doc) return null;
  const obj = doc.toObject ? doc.toObject() : doc;

  return {
    id: obj._id?.toString() || obj.id,
    description: obj.description,
    images: obj.images || [],
    createdAt: obj.createdAt,
    updatedAt: obj.updatedAt,
  };
};

// ✅ Upload file to Cloudinary
const uploadToCloudinary = async (filePath, folder = "matches_gallery") => {
  try {
    console.log("Uploading file to Cloudinary:", filePath);

    // Check if file exists
    if (!fs.existsSync(filePath)) {
      throw new Error(`File not found: ${filePath}`);
    }

    const result = await cloudinary.uploader.upload(filePath, {
      folder,
      resource_type: "auto"
    });

    console.log("Cloudinary upload successful:", result.secure_url);

    // Delete local file after upload
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }

    return result.secure_url;
  } catch (error) {
    console.error("Cloudinary upload error:", error);

    // Clean up local file if upload fails
    if (fs.existsSync(filePath)) {
      fs.unlinkSync(filePath);
    }
    throw error;
  }
};

// ✅ Validate MongoDB ID
const isValidObjectId = (id) => mongoose.Types.ObjectId.isValid(id);

// ✅ Extract public ID from Cloudinary URL
const getPublicIdFromUrl = (url) => {
  try {
    const urlParts = url.split('/');
    const filename = urlParts[urlParts.length - 1];
    return `matches_gallery/${filename.split('.')[0]}`;
  } catch (error) {
    console.error("Error extracting public ID:", error);
    return null;
  }
};

//
// CREATE MatchesGallery - DEBUG VERSION
//
export const createMatchesGallery = async (req) => {
  console.log("Request body:", req.body);
  console.log("Request files:", req.files);
  console.log("Request file:", req.file);

  const { description } = req.body;

  if (!description || description.trim() === '') {
    return { statusCode: 400, body: { success: false, message: "Description is required" } };
  }

  // Handle gallery images - DEBUGGING
  let galleryImages = [];

  console.log("Files received:", req.files);
  console.log("File received:", req.file);

  // Check both req.files (array) and req.file (single file)
  const files = req.files || (req.file ? [req.file] : []);

  console.log("Processing files:", files);

  if (files && files.length > 0) {
    console.log(`Found ${files.length} files to upload`);

    for (const file of files) {
      try {
        console.log("Processing file:", file);
        console.log("File path:", file.path);
        console.log("File size:", file.size);

        const url = await uploadToCloudinary(file.path);
        galleryImages.push(url);
        console.log("Successfully uploaded image:", url);
      } catch (uploadError) {
        console.error("Error uploading image to Cloudinary:", uploadError);
        // Continue with other images even if one fails
      }
    }
  } else {
    console.log("No files found in request");
  }

  console.log("Final images array:", galleryImages);

  try {
    const newGallery = new MatchesGallery({
      description: description.trim(),
      images: galleryImages
    });

    const savedGallery = await newGallery.save();
    console.log("Gallery saved to database:", savedGallery);

    return {
      statusCode: 201,
      body: {
        success: true,
        message: "Gallery created successfully",
        data: transformGallery(savedGallery)
      },
    };
  } catch (error) {
    // Clean up any uploaded files if creation fails
    if (req.files) {
      req.files.forEach(file => {
        if (fs.existsSync(file.path)) {
          fs.unlinkSync(file.path);
        }
      });
    }
    throw error;
  }
};

//
// GET All
//
export const getAllMatchesGallery = async () => {
  const galleryList = await MatchesGallery.find().sort({ createdAt: -1 });

  return {
    statusCode: 200,
    body: {
      success: true,
      count: galleryList.length,
      data: galleryList.map(transformGallery)
    },
  };
};

//
// GET By ID
//
export const getMatchesGalleryById = async (id) => {
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid Gallery ID format" } };
  }

  const gallery = await MatchesGallery.findById(id);
  if (!gallery) {
    return { statusCode: 404, body: { success: false, message: "Gallery item not found" } };
  }

  return { statusCode: 200, body: { success: true, data: transformGallery(gallery) } };
};

//
// UPDATE
//
export const updateMatchesGallery = async (req) => {
  const { id } = req.params;

  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid Gallery ID format" } };
  }

  const existingGallery = await MatchesGallery.findById(id);
  if (!existingGallery) {
    return { statusCode: 404, body: { success: false, message: "Gallery item not found" } };
  }

  const { description } = req.body;

  // Update gallery images - add new images to existing ones
  let updatedImages = [...existingGallery.images];

  const files = req.files || (req.file ? [req.file] : []);

  if (files && files.length > 0) {
    for (const file of files) {
      try {
        const url = await uploadToCloudinary(file.path);
        updatedImages.push(url);
      } catch (uploadError) {
        console.error("Error uploading image to Cloudinary:", uploadError);
      }
    }
  }

  const updatedGallery = await MatchesGallery.findByIdAndUpdate(
    id,
    {
      description: description ? description.trim() : existingGallery.description,
      images: updatedImages
    },
    { new: true, runValidators: true }
  );

  return {
    statusCode: 200,
    body: {
      success: true,
      message: "Gallery updated successfully",
      data: transformGallery(updatedGallery)
    },
  };
};

//
// DELETE
//
export const deleteMatchesGallery = async (id) => {
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid Gallery ID format" } };
  }

  const gallery = await MatchesGallery.findById(id);
  if (!gallery) {
    return { statusCode: 404, body: { success: false, message: "Gallery item not found" } };
  }

  // Delete images from Cloudinary
  if (gallery.images && gallery.images.length > 0) {
    for (const imageUrl of gallery.images) {
      try {
        const publicId = getPublicIdFromUrl(imageUrl);
        if (publicId) {
          await cloudinary.uploader.destroy(publicId);
        }
      } catch (cloudinaryError) {
        console.error("Error deleting image from Cloudinary:", cloudinaryError);
      }
    }
  }

  await MatchesGallery.findByIdAndDelete(id);

  return { statusCode: 200, body: { success: true, message: "Gallery item deleted successfully" } };
};

//
// DELETE single image from gallery item
//
export const deleteGalleryImage = async (id, imageIndex) => {
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid Gallery ID format" } };
  }

  const gallery = await MatchesGallery.findById(id);
  if (!gallery) {
    return { statusCode: 404, body: { success: false, message: "Gallery item not found" } };
  }

  const index = parseInt(imageIndex);
  if (isNaN(index) || index < 0 || index >= gallery.images.length) {
    return { statusCode: 400, body: { success: false, message: "Invalid image index" } };
  }

  // Delete image from Cloudinary
  const imageUrl = gallery.images[index];
  try {
    const publicId = getPublicIdFromUrl(imageUrl);
    if (publicId) {
      await cloudinary.uploader.destroy(publicId);
    }
  } catch (cloudinaryError) {
    console.error("Error deleting image from Cloudinary:", cloudinaryError);
  }

  // Remove image from array
  gallery.images.splice(index, 1);
  await gallery.save();

  return {
    statusCode: 200,
    body: {
      success: true,
      message: "Image deleted successfully",
      data: transformGallery(gallery)
    },
  };
};
