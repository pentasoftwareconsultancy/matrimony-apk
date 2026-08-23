

import express from "express";
import {
  createEvent,
  getAllEvents,
  getEventById,
  updateEvent,
  deleteEvent,
} from "./event.controller.js";
import upload from "../../middleware/multer.js";

const eventrouter = express.Router();

// Middleware: handle both JSON and multipart/form-data
function conditionalUpload(req, res, next) {
  const contentType = req.headers["content-type"] || "";

  if (contentType.includes("multipart/form-data")) {
    return upload.fields([
      { name: "img", maxCount: 1 },
      { name: "imageScroll", maxCount: 10 },
    ])(req, res, (err) => {
      if (err) {
        console.error("Multer error:", err);
        return res.status(400).json({
          success: false,
          error: "File upload error: " + err.message
        });
      }
      next();
    });
  }

  express.json()(req, res, next);
}

// RESTful routes
// CHANGED: Routes are now relative to '/api/events'
eventrouter.post("/", conditionalUpload, createEvent);      // POST /api/events
eventrouter.get("/", getAllEvents);                         // GET /api/events
eventrouter.get("/:id", getEventById);                      // GET /api/events/:id
eventrouter.put("/:id", conditionalUpload, updateEvent);    // PUT /api/events/:id
eventrouter.delete("/:id", deleteEvent);                    // DELETE /api/events/:id

export default eventrouter;