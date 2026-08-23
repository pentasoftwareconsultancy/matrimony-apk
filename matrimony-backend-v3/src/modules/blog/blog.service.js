import Blog from "./blog.schema.js";
import cloudinary from "../../config/cloudinary.js";
import fs from "fs";
import mongoose from "mongoose";

const uploadToCloudinary = async (filePath, folder = "blog_images") => {
  const result = await cloudinary.uploader.upload(filePath, { folder });
  fs.unlinkSync(filePath);
  return result.secure_url;
};

const isValidObjectId = (id) => mongoose.Types.ObjectId.isValid(id);

export const createBlog = async (req) => {
  const {
    heading,
    subHeading,
    date,
    title,
    description,
    eventName,
    eventInfo,
  } = req.body;

  if (
    !heading ||
    !subHeading ||
    !date ||
    !title ||
    !description ||
    !eventName
  ) {
    return {
      statusCode: 400,
      success: false,
      message: "Missing required fields.",
    };
  }

  let imgUrl = null;

  if (req.files?.img?.[0]) {
    imgUrl = await uploadToCloudinary(req.files.img[0].path);
  } else if (req.body.img) {
    imgUrl = req.body.img;
  }

  let imageScrollUrls = [];

  if (req.files?.imageScroll) {
    for (const file of req.files.imageScroll) {
      imageScrollUrls.push(await uploadToCloudinary(file.path));
    }
  } else if (req.body.imageScroll) {
    imageScrollUrls = Array.isArray(req.body.imageScroll)
      ? req.body.imageScroll
      : [req.body.imageScroll];
  }

  let parsedEventInfo = [];

  if (eventInfo) {
    try {
      parsedEventInfo =
        typeof eventInfo === "string"
          ? JSON.parse(eventInfo)
          : eventInfo;
    } catch {
      return {
        statusCode: 400,
        success: false,
        message: "Invalid eventInfo format.",
      };
    }
  }

  const blog = await Blog.create({
    heading,
    subHeading,
    date,
    title,
    description,
    eventName,
    img: imgUrl,
    imageScroll: imageScrollUrls,
    eventInfo: parsedEventInfo,
  });

  return {
    statusCode: 201,
    success: true,
    message: "Blog created successfully.",
    data: blog,
  };
};

export const getAllBlogs = async () => {
  const blogs = await Blog.find().sort({ date: -1 });

  return {
    statusCode: 200,
    success: true,
    data: blogs,
  };
};

export const getBlogById = async (id) => {
  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      success: false,
      message: "Invalid blog ID format.",
    };
  }

  const blog = await Blog.findById(id);

  if (!blog) {
    return {
      statusCode: 404,
      success: false,
      message: "Blog not found.",
    };
  }

  return {
    statusCode: 200,
    success: true,
    data: blog,
  };
};

export const updateBlog = async (req) => {
  const { id } = req.params;

  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      success: false,
      message: "Invalid blog ID format.",
    };
  }

  const existingBlog = await Blog.findById(id);

  if (!existingBlog) {
    return {
      statusCode: 404,
      success: false,
      message: "Blog not found.",
    };
  }

  const {
    heading,
    subHeading,
    date,
    title,
    description,
    eventName,
    eventInfo,
  } = req.body;

  let updatedImg = existingBlog.img;

  if (req.files?.img?.[0]) {
    updatedImg = await uploadToCloudinary(req.files.img[0].path);
  } else if (req.body.img) {
    updatedImg = req.body.img;
  }

  let updatedImageScroll = existingBlog.imageScroll || [];

  if (req.files?.imageScroll) {
    updatedImageScroll = [];

    for (const file of req.files.imageScroll) {
      updatedImageScroll.push(await uploadToCloudinary(file.path));
    }
  } else if (req.body.imageScroll) {
    updatedImageScroll = Array.isArray(req.body.imageScroll)
      ? req.body.imageScroll
      : [req.body.imageScroll];
  }

  const parsedEventInfo = eventInfo
    ? typeof eventInfo === "string"
      ? JSON.parse(eventInfo)
      : eventInfo
    : existingBlog.eventInfo;

  const updatedBlog = await Blog.findByIdAndUpdate(
    id,
    {
      heading,
      subHeading,
      date,
      title,
      description,
      eventName,
      img: updatedImg,
      imageScroll: updatedImageScroll,
      eventInfo: parsedEventInfo,
    },
    {
      new: true,
      runValidators: true,
    }
  );

  return {
    statusCode: 200,
    success: true,
    message: "Blog updated successfully.",
    data: updatedBlog,
  };
};

export const deleteBlog = async (id) => {
  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      success: false,
      message: "Invalid blog ID format.",
    };
  }

  const blog = await Blog.findById(id);

  if (!blog) {
    return {
      statusCode: 404,
      success: false,
      message: "Blog not found.",
    };
  }

  if (blog.img) {
    const publicId = blog.img.split("/").pop().split(".")[0];
    await cloudinary.uploader.destroy(`blog_images/${publicId}`);
  }

  if (blog.imageScroll?.length) {
    for (const url of blog.imageScroll) {
      const publicId = url.split("/").pop().split(".")[0];
      await cloudinary.uploader.destroy(`blog_images/${publicId}`);
    }
  }

  await Blog.findByIdAndDelete(id);

  return {
    statusCode: 200,
    success: true,
    message: "Blog deleted successfully.",
  };
};