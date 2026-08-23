import Event from "./event.schema.js";
import cloudinary from "../../config/cloudinary.js";
import fs from "fs";
import mongoose from "mongoose";

const uploadToCloudinary = async (filePath, folder = "event_images") => {
  const result = await cloudinary.uploader.upload(filePath, { folder });
  fs.unlinkSync(filePath);
  return result.secure_url;
};

const isValidObjectId = (id) => mongoose.Types.ObjectId.isValid(id);

export const createEvent = async (req) => {
  const {
    heading,
    subHeading,
    date,
    title,
    description,
    eventInfo,
    schedule,
  } = req.body;

  if (!heading || !subHeading || !date) {
    return {
      statusCode: 400,
      data: {
        success: false,
        message: "Missing required fields (heading, subHeading, date).",
      },
    };
  }

  let imageUrl = null;

  if (req.files?.img?.[0]) {
    imageUrl = await uploadToCloudinary(req.files.img[0].path);
  } else if (req.body.img) {
    imageUrl = req.body.img;
  }

  let galleryUrls = [];

  if (req.files?.imageScroll) {
    for (const file of req.files.imageScroll) {
      galleryUrls.push(await uploadToCloudinary(file.path));
    }
  } else if (req.body.imageScroll) {
    galleryUrls = Array.isArray(req.body.imageScroll)
      ? req.body.imageScroll
      : [req.body.imageScroll];
  }

  let parsedEventInfo = {};

  if (eventInfo) {
    parsedEventInfo =
      typeof eventInfo === "string"
        ? JSON.parse(eventInfo)
        : eventInfo;
  }

  let parsedSchedule = [];

  if (schedule) {
    parsedSchedule =
      typeof schedule === "string"
        ? JSON.parse(schedule)
        : schedule;
  }

  const event = await Event.create({
    heading,
    subHeading,
    img: imageUrl,
    date,
    title,
    description,
    imageScroll: galleryUrls,
    eventInfo: parsedEventInfo,
    schedule: parsedSchedule,
  });

  return {
    statusCode: 201,
    data: event,
  };
};

export const getAllEvents = async () => {
  const events = await Event.find().sort({ createdAt: -1 });

  return {
    statusCode: 200,
    data: events,
  };
};

export const getEventById = async (id) => {
  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      data: {
        success: false,
        message: "Invalid event ID format",
      },
    };
  }

  const event = await Event.findById(id);

  if (!event) {
    return {
      statusCode: 404,
      data: {
        success: false,
        message: "Event not found",
      },
    };
  }

  return {
    statusCode: 200,
    data: event,
  };
};

export const updateEvent = async (req) => {
  const { id } = req.params;

  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      data: {
        success: false,
        message: "Invalid event ID format",
      },
    };
  }

  const existingEvent = await Event.findById(id);

  if (!existingEvent) {
    return {
      statusCode: 404,
      data: {
        success: false,
        message: "Event not found.",
      },
    };
  }

  const {
    heading,
    subHeading,
    date,
    title,
    description,
    eventInfo,
    schedule,
  } = req.body;

  let updatedImg = existingEvent.img;

  if (req.files?.img?.[0]) {
    updatedImg = await uploadToCloudinary(req.files.img[0].path);
  } else if (req.body.img) {
    updatedImg = req.body.img;
  }

  let updatedGallery = existingEvent.imageScroll || [];

  if (req.files?.imageScroll) {
    updatedGallery = [];

    for (const file of req.files.imageScroll) {
      updatedGallery.push(await uploadToCloudinary(file.path));
    }
  } else if (req.body.imageScroll) {
    updatedGallery = Array.isArray(req.body.imageScroll)
      ? req.body.imageScroll
      : [req.body.imageScroll];
  }

  const parsedEventInfo = eventInfo
    ? typeof eventInfo === "string"
      ? JSON.parse(eventInfo)
      : eventInfo
    : existingEvent.eventInfo;

  const parsedSchedule = schedule
    ? typeof schedule === "string"
      ? JSON.parse(schedule)
      : schedule
    : existingEvent.schedule;

  const updatedEvent = await Event.findByIdAndUpdate(
    id,
    {
      heading,
      subHeading,
      img: updatedImg,
      date,
      title,
      description,
      imageScroll: updatedGallery,
      eventInfo: parsedEventInfo,
      schedule: parsedSchedule,
    },
    {
      new: true,
      runValidators: true,
    }
  );

  return {
    statusCode: 200,
    data: updatedEvent,
  };
};

export const deleteEvent = async (id) => {
  if (!isValidObjectId(id)) {
    return {
      statusCode: 400,
      data: {
        success: false,
        message: "Invalid event ID format",
      },
    };
  }

  const event = await Event.findById(id);

  if (!event) {
    return {
      statusCode: 404,
      data: {
        success: false,
        message: "Event not found.",
      },
    };
  }

  if (event.img) {
    const publicId = event.img.split("/").pop().split(".")[0];
    await cloudinary.uploader.destroy(`event_images/${publicId}`);
  }

  await Event.findByIdAndDelete(id);

  return {
    statusCode: 200,
    data: {
      success: true,
      message: "Event deleted successfully.",
    },
  };
};