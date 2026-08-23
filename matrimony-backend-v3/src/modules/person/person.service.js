import Person from "./person.schema.js";
import cloudinary from "../../config/cloudinary.js";
import fs from "fs";
import mongoose from "mongoose";

const transformPerson = (doc) => {
  if (!doc) return null;
  const obj = doc.toObject ? doc.toObject() : doc;

  return {
    id: obj._id?.toString() || obj.id,
    name: obj.name,
    designation: obj.designation,
    age: obj.age,
    location: obj.location,
    place: obj.place, // Added place field
    experience: obj.experience,
    biography: obj.biography,
    image: obj.image,
    createdAt: obj.createdAt,
    updatedAt: obj.updatedAt,
  };
};

const uploadToCloudinary = async (filePath, folder = "person_images") => {
  const result = await cloudinary.uploader.upload(filePath, { folder });
  fs.unlinkSync(filePath);
  return result.secure_url;
};

const isValidObjectId = (id) => mongoose.Types.ObjectId.isValid(id);

export const createPerson = async (req) => {
  const { name, designation, age, location, place, experience, biography } = req.body;

  if (!name || !designation || !place) {
    return {
      statusCode: 400,
      body: { success: false, message: "Name, Designation, and Place are required" },
    };
  }

  if (!["Pune", "Akole"].includes(place)) {
    return {
      statusCode: 400,
      body: { success: false, message: "Place must be either 'Pune' or 'Akole'" },
    };
  }

  let imageUrl = null;
  if (req.file) {
    imageUrl = await uploadToCloudinary(req.file.path);
  } else if (req.body.image) {
    imageUrl = req.body.image;
  }

  const newPerson = new Person({
    name,
    designation,
    age,
    location,
    place, // Added place
    experience,
    biography,
    image: imageUrl,
  });

  const savedPerson = await newPerson.save();
  return { statusCode: 201, body: transformPerson(savedPerson) };
};

export const getAllPersons = async (req) => {
  const { place } = req.query; // Get place from query params
  let query = {};

  if (place && ["Pune", "Akole"].includes(place)) {
    query.place = place;
  }

  const persons = await Person.find(query).sort({ createdAt: -1 });
  return { statusCode: 200, body: persons.map(transformPerson) };
};

export const getPersonsByPlace = async (place) => {
  if (!["Pune", "Akole"].includes(place)) {
    return {
      statusCode: 400,
      body: { success: false, message: "Invalid place. Must be 'Pune' or 'Akole'" },
    };
  }

  const persons = await Person.find({ place }).sort({ createdAt: -1 });
  return { statusCode: 200, body: persons.map(transformPerson) };
};

export const getPersonById = async (id) => {
  try {
    const person = await Person.findById(id);
    if (!person) {
      return { statusCode: 404, body: { message: "Person not found" } };
    }
    return { statusCode: 200, body: transformPerson(person) };
  } catch (error) {
    return { statusCode: 400, body: { message: error.message } };
  }
};

export const updatePerson = async (req) => {
  const { id } = req.params;
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid person ID format" } };
  }

  const existing = await Person.findById(id);
  if (!existing) {
    return { statusCode: 404, body: { success: false, message: "Person not found" } };
  }

  const { name, designation, age, location, place, experience, biography } = req.body;

  if (place && !["Pune", "Akole"].includes(place)) {
    return {
      statusCode: 400,
      body: { success: false, message: "Place must be either 'Pune' or 'Akole'" },
    };
  }

  let updatedImage = existing.image;
  if (req.file) {
    updatedImage = await uploadToCloudinary(req.file.path);
  } else if (req.body.image) {
    updatedImage = req.body.image;
  }

  const updatedPerson = await Person.findByIdAndUpdate(
    id,
    {
      name,
      designation,
      age,
      location,
      place: place || existing.place,
      experience,
      biography,
      image: updatedImage,
    },
    { new: true, runValidators: true }
  );

  return { statusCode: 200, body: transformPerson(updatedPerson) };
};

export const deletePerson = async (id) => {
  if (!isValidObjectId(id)) {
    return { statusCode: 400, body: { success: false, message: "Invalid person ID format" } };
  }

  const person = await Person.findById(id);
  if (!person) {
    return { statusCode: 404, body: { success: false, message: "Person not found" } };
  }

  if (person.image) {
    const publicId = person.image.split("/").pop().split(".")[0];
    await cloudinary.uploader.destroy(`person_images/${publicId}`);
  }

  await Person.findByIdAndDelete(id);
  return { statusCode: 200, body: { success: true, message: "Person deleted successfully" } };
};
