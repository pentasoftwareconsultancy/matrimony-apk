import mongoose from "mongoose";

const eventSchema = new mongoose.Schema(
  {
    heading: { type: String, required: true },
    subHeading: { type: String, required: true },
    img: { type: String },
    date: { type: String, required: true },

    title: { type: String },
    description: { type: String },

    imageScroll: [{ type: String }],

    eventInfo: [
      {
        Date: { type: String },
        Time: { type: String },
        Location: { type: String },
        Organizers: { type: String },
      },
    ],

    schedule: [
      {
        time: { type: String },
        event: { type: String },
      },
    ],
  },
  { timestamps: true, collection: "events" }
);

const Event = mongoose.models.Event || mongoose.model("Event", eventSchema);
export default Event;
