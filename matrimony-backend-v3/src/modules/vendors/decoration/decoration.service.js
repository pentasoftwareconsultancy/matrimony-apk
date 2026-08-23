import Decoration from "./decoration.schema.js";
import cloudinary from "../../../config/cloudinary.js";
import uploadToCloudinary from "../../../utils/uploadCloudinary.js";
// import { isValidObjectId } from "../utils/mongo.util.js";

const transformDecoration = (doc) => {
  if (!doc) return null;

  const obj = doc.toObject ? doc.toObject() : doc;

  return {
    id: obj._id?.toString(),
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

export const createDecoration = async (req) => {
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
      "decoration_images"
    );
  } else if (req.body.image) {
    mainImage = req.body.image;
  }

  let gallery = [];

  if (req.files?.images) {
    for (const file of req.files.images) {
      gallery.push(
        await uploadToCloudinary(file.path, "decoration_images")
      );
    }
  } else if (req.body.images) {
    gallery = Array.isArray(req.body.images)
      ? req.body.images
      : [req.body.images];
  }

  const decoration = await Decoration.create({
    name,
    studio,
    location,
    projects,
    phone,
    detailname,
    image: mainImage,
    images: gallery,
    about,
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
    message: "Decoration created successfully.",
    data: transformDecoration(decoration),
  };
};

export const getAllDecorations = async () => {
  const decorations = await Decoration.find().sort({
    createdAt: -1,
  });

  return {
    statusCode: 200,
    success: true,
    data: decorations.map(transformDecoration),
  };
};

export const getDecorationById = async (id) => {
  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      success: false,
      message: "Invalid decoration ID format",
    };
  }

  const decoration = await Decoration.findById(id);

  if (!decoration) {
    return {
      statusCode: 404,
      success: false,
      message: "Decoration not found",
    };
  }

  return {
    statusCode: 200,
    success: true,
    data: transformDecoration(decoration),
  };
};

export const updateDecoration = async (req) => {
  const { id } = req.params;

  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      success: false,
      message: "Invalid decoration ID format",
    };
  }

  const existing = await Decoration.findById(id);

  if (!existing) {
    return {
      statusCode: 404,
      success: false,
      message: "Decoration not found",
    };
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

  let mainImage = existing.image;

  if (req.files?.image?.[0]) {
    mainImage = await uploadToCloudinary(
      req.files.image[0].path,
      "decoration_images"
    );
  } else if (req.body.image) {
    mainImage = req.body.image;
  }

  let gallery = existing.images || [];

  if (req.files?.images) {
    gallery = [];

    for (const file of req.files.images) {
      gallery.push(
        await uploadToCloudinary(file.path, "decoration_images")
      );
    }
  } else if (req.body.images) {
    gallery = Array.isArray(req.body.images)
      ? req.body.images
      : [req.body.images];
  }

  const updated = await Decoration.findByIdAndUpdate(
    id,
    {
      name,
      studio,
      location,
      projects,
      phone,
      detailname,
      image: mainImage,
      images: gallery,
      about,
      pricing: pricing
        ? typeof pricing === "string"
          ? JSON.parse(pricing)
          : pricing
        : existing.pricing,
      specializations: specializations
        ? typeof specializations === "string"
          ? JSON.parse(specializations)
          : specializations
        : existing.specializations,
      reviews: reviews
        ? typeof reviews === "string"
          ? JSON.parse(reviews)
          : reviews
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
    message: "Decoration updated successfully.",
    data: transformDecoration(updated),
  };
};

export const deleteDecoration = async (id) => {
  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      success: false,
      message: "Invalid decoration ID format",
    };
  }

  const decoration = await Decoration.findById(id);

  if (!decoration) {
    return {
      statusCode: 404,
      success: false,
      message: "Decoration not found",
    };
  }

  if (decoration.image) {
    const publicId = decoration.image.split("/").pop().split(".")[0];
    await cloudinary.uploader.destroy(`decoration_images/${publicId}`);
  }

  await Decoration.findByIdAndDelete(id);

  return {
    statusCode: 200,
    success: true,
    message: "Decoration deleted successfully.",
  };
};