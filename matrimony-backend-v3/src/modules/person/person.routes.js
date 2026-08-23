
import express from "express";
import {
  createPerson,
  getAllPersons,
  getPersonById,
  updatePerson,
  deletePerson,
  getPersonsByPlace, // New function
} from "./person.controller.js"; 
import upload from "../../middleware/multer.js";

const router = express.Router();

router.post("/", upload.single("image"), createPerson);
router.get("/", getAllPersons); // Can use ?place=Pune or ?place=Akole
router.get("/place/:place", getPersonsByPlace); // New route for place filtering
router.get("/:id", getPersonById);
router.put("/:id", upload.single("image"), updatePerson);
router.delete("/:id", deletePerson);

export default router;