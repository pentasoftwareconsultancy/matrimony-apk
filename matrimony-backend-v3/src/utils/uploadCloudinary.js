// This is helper function where we upload files to Cloudinary


import cloudinary from '../config/cloudinary.js';

const uploadToCloudinary = async (file, options = {}) => {
  const base64 = `data:${file.mimetype};base64,${file.buffer.toString("base64")}`;
  const uploaded = await cloudinary.uploader.upload(base64, options);
  return uploaded.secure_url;
};

export default uploadToCloudinary;