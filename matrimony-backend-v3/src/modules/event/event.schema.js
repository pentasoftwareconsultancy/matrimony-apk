import mongoose from "mongoose";

const EventSchema = new mongoose.Schema(
  {
    // Card Data
    heading: { type: String, required: true },
    subHeading: { type: String, required: true },
    img: { type: String }, // main thumbnail image
    date: { type: String, required: true },

    title: { type: String }, // detailed title for event
    description: { type: String }, // long event description

    // multiple images for gallery/scroll
    imageScroll: [{ type: String }],

    // event info like time, location, organizers
    eventInfo: [
      {
        Date: { type: String },
        Time: { type: String },
        Location: { type: String },
        Organizers: { type: String },
      },
    ],

    // schedule/timeline
    schedule: [
      {
        time: { type: String },
        event: { type: String },
      },
    ],
  },
  { timestamps: true }
);

export default mongoose.model("Event", EventSchema);
