import Contact from "./contact.schema.js";
import { sendEmail } from "../../utils/sendEmail.js";
import { sendSMS } from "../../utils/sendSMS.js";

export const submitContact = async (data) => {
    try {
        const { name, email, mobileNumber, message } = data;

        if (!name || !email || !mobileNumber || !message) {
            return {
                statusCode: 400,
                success: false,
                message:
                    "All fields (name, email, mobile number, message) are required",
            };
        }

        const contact = await Contact.create({
            name,
            email,
            mobileNumber,
            message,
        });

        // User Confirmation Email
        try {
            await sendEmail({
                to: email,
                subject: "Thank You for Your Inquiry - Matrimonial Platform",
                text: `Dear ${name},

Thank you for contacting us!

We have received your message:

"${message}"

Our team will review and respond within 1-2 business days.

Best Regards,
Matrimony Support Team`,
            });
        } catch (error) {
            console.error("User email failed:", error.message);
        }

        // Admin Email
        try {
            const adminEmail = process.env.SENDER_EMAIL;

            if (adminEmail) {
                await sendEmail({
                    to: adminEmail,
                    subject: "New Contact Form Submission Received",
                    text: `A new contact form submission has been received.

Name: ${name}
Email: ${email}
Mobile Number: ${mobileNumber}

Message:
${message}

Submitted on:
${new Date().toLocaleString()}`,
                });
            }
        } catch (error) {
            console.error("Admin email failed:", error.message);
        }

        // Admin SMS
        try {
            const adminPhoneNumber = process.env.ADMIN_PHONE_NUMBER;

            if (adminPhoneNumber) {
                await sendSMS({
                    to: adminPhoneNumber,
                    body: `New Contact:
${name}
${mobileNumber}`,
                });
            }
        } catch (error) {
            console.error("SMS failed:", error.message);
        }

        return {
            statusCode: 201,
            success: true,
            message: "Contact form submitted successfully",
            data: {
                id: contact._id,
                name,
                email,
                mobileNumber,
                message,
            },
        };
    } catch (error) {
        console.error("Contact submission error:", error);

        if (error.name === "ValidationError") {
            return {
                statusCode: 400,
                success: false,
                message: "Validation error",
                errors: error.errors,
            };
        }

        throw error;
    }
};

export const getAllContacts = async () => {
    try {
        const contacts = await Contact.find().sort({ createdAt: -1 });

        return {
            statusCode: 200,
            success: true,
            message: "Contact submissions fetched successfully",
            data: contacts,
        };
    } catch (error) {
        console.error("Error fetching contacts:", error);
        throw error;
    }
};