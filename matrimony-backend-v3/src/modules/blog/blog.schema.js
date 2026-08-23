// models/Blog.js
import mongoose from "mongoose";

const { Schema, model } = mongoose;

const EventInfoSchema = new Schema({
  Date: { type: String, required: true },       // e.g., "25 September 2025"
  Time: { type: String, required: true },       // e.g., "10:00 AM - 2:00 PM"
  Location: { type: String, required: true },   // e.g., "Mumbai, India"
  Organizers: { type: String, required: true }, // e.g., "Matrimony Org"
});

const BlogSchema = new Schema({
  heading: { type: String, required: true },        // Blog heading/title
  subHeading: { type: String, required: true },     // Blog subtitle
  date: { type: String, required: true },           // Main blog date, e.g., "25 September 2025"
  img: { type: String, required: true },            // Cover image URL
  imageScroll: [{ type: String }],                  // Array of images for detail view
  eventInfo: [EventInfoSchema],                     // Array of event info objects
  eventName: { type: String, required: true },      // Event name in detail page
  title: { type: String, required: true },          // Blog title in detail page
  description: { type: String, required: true },    // Blog description/content
}, { timestamps: true });

export default model("Blog", BlogSchema);
