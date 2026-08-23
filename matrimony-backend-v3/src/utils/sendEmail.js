
import nodemailer from 'nodemailer';
import dotenv from 'dotenv';

dotenv.config();

const sendEmail = async ({ to, subject, text, html }) => {
  try {
    // Verify environment variables
    if (!process.env.EMAIL_ADDRESS || !process.env.EMAIL_PASSWORD || !process.env.SENDER_EMAIL) {
      throw new Error('Missing EMAIL_ADDRESS, EMAIL_PASSWORD, or SENDER_EMAIL in environment variables');
    }

    // Create transporter for Brevo SMTP
    const transporter = nodemailer.createTransport({
      host: 'smtp-relay.brevo.com',
      port: 587,
      secure: false, // Use TLS
      auth: {
        user: process.env.EMAIL_ADDRESS, // 907819002@smtp-brevo.com
        pass: process.env.EMAIL_PASSWORD, // kc9Iq3vdnmyT1R5K
      },
      logger: true, // Enable detailed logging
      debug: true, // Show SMTP communication
      tls: {
        ciphers: 'SSLv3', // Fallback for compatibility
        rejectUnauthorized: false, // Use with caution, only for testing
      },
    });

    // Verify transporter connection
    try {
      await transporter.verify();
      console.log(`✅ SMTP connection verified for ${process.env.EMAIL_ADDRESS} at ${new Date().toISOString()}`);
    } catch (verifyError) {
      console.error(`❌ SMTP connection verification failed at ${new Date().toISOString()}:`, verifyError);
      throw new Error(`SMTP connection failed: ${verifyError.message}`);
    }

    // Email options
    const mailOptions = {
      from: `"Matrimony Platform" <${process.env.SENDER_EMAIL}>`, // sonaliekhande12@gmail.com
      to,
      subject,
      text,
      html, // Include HTML content if provided
    };

    // Send email
    const info = await transporter.sendMail(mailOptions);
    console.log(`✅ Email sent to ${to} at ${new Date().toISOString()}: ${info.messageId}`);
    return { success: true, messageId: info.messageId };
  } catch (error) {
    console.error(`❌ Error sending email to ${to} at ${new Date().toISOString()}:`, error);
    throw new Error(`Failed to send email: ${error.message}`);
  }
};

export { sendEmail };