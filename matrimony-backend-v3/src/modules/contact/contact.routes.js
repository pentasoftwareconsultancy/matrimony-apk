import express from 'express';
import { submitContact, getAllContacts } from './contact.controller.js';

const router = express.Router();
router.post('/contact', submitContact);
router.get('/getcontact', getAllContacts);

export default router;
