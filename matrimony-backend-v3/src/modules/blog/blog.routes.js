// routes/blogRoutes.js
import express from "express";
import multer from "multer";
import {
  createBlog,
  getAllBlogs,
  getBlogById,
  updateBlog,
  deleteBlog,
} from "./blog.controller.js";

const blogrouter = express.Router();

// Multer setup for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/"); // Temporary folder
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + "-" + file.originalname);
  },
});

const upload = multer({ storage });

// Routes

// GET all blogs
blogrouter.get("/", getAllBlogs);

// GET single blog by ID
blogrouter.get("/:id", getBlogById);

// CREATE blog with file uploads (img + imageScroll)
blogrouter.post(
  "/",
  upload.fields([
    { name: "img", maxCount: 1 },
    { name: "imageScroll", maxCount: 10 },
  ]),
  createBlog
);

// UPDATE blog by ID with file uploads
blogrouter.put(
  "/:id",
  upload.fields([
    { name: "img", maxCount: 1 },
    { name: "imageScroll", maxCount: 10 },
  ]),
  updateBlog
);

// DELETE blog by ID
blogrouter.delete("/:id", deleteBlog);

export default blogrouter;
