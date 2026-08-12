import nodemailer from 'nodemailer';

export const sendEmail = async ({ to, subject, html }) => {
  const senderEmail = process.env.SENDER_EMAIL || process.env.EMAIL_ADDRESS;
  
  if (!process.env.EMAIL_ADDRESS || !process.env.EMAIL_PASSWORD) {
    console.warn('\n==================================================');
    console.warn(`[MAILER MOCK] Sending email to: ${to}`);
    console.warn(`[MAILER MOCK] Subject: ${subject}`);
    console.warn(`[MAILER MOCK] Content:\n${html.replace(/<[^>]*>/g, ' ')}`);
    console.warn('==================================================\n');
    return { mock: true };
  }

  const transporter = nodemailer.createTransport({
    service: 'gmail', // Fallback to gmail or custom SMTP
    auth: {
      user: process.env.EMAIL_ADDRESS,
      pass: process.env.EMAIL_PASSWORD,
    },
  });

  const mailOptions = {
    from: `"Matrimony Support" <${senderEmail}>`,
    to,
    subject,
    html,
  };

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log(`Email sent successfully: ${info.messageId}`);
    return info;
  } catch (error) {
    console.error('Email sending failed:', error.message);
    // In local development, don't crash the server, just log and fallback
    console.warn('\n==================================================');
    console.warn(`[MAILER ERROR FALLBACK] Failed to send email to: ${to}`);
    console.warn(`[MAILER ERROR FALLBACK] Subject: ${subject}`);
    console.warn(`[MAILER ERROR FALLBACK] Content:\n${html.replace(/<[^>]*>/g, ' ')}`);
    console.warn('==================================================\n');
    return { error: true, message: error.message };
  }
};

export const sendOTPEmail = async (to, otp) => {
  return await sendEmail({
    to,
    subject: 'Matrimony App - Verify Your Account / Reset Password',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 5px;">
        <h2 style="color: #d81b60; text-align: center;">Matrimony App</h2>
        <p>Hello,</p>
        <p>Thank you for choosing Matrimony App. Use the following One-Time Password (OTP) to complete your verification or password reset request. This OTP is valid for 10 minutes.</p>
        <div style="text-align: center; margin: 30px 0;">
          <span style="font-size: 32px; font-weight: bold; letter-spacing: 5px; color: #d81b60; border: 1px dashed #d81b60; padding: 10px 20px; background-color: #fff9fb;">
            ${otp}
          </span>
        </div>
        <p>If you did not make this request, please ignore this email.</p>
        <hr style="border: none; border-top: 1px solid #eee;" />
        <p style="font-size: 12px; color: #888; text-align: center;">
          This is an automated message, please do not reply.
        </p>
      </div>
    `
  });
};
