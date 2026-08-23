import fetch from 'node-fetch';
import dotenv from 'dotenv';

dotenv.config();

const sendSMS = async ({ to, body, sender = 'Matrimony' }) => {
  try {
    if (!process.env.BREVO_SMS_API_KEY) {
      throw new Error('Missing BREVO_SMS_API_KEY in environment variables');
    }

    // Validate E.164 format
    if (!/^\+\d{10,15}$/.test(to)) {
      throw new Error(`Invalid phone number format: ${to}. Expected E.164 (e.g., +911234567890)`);
    }

    if (!body) {
      throw new Error('SMS content is required');
    }

    console.log('Sending SMS with:', { to, body, sender });

    const response = await fetch('https://api.brevo.com/v3/transactionalSMS/sms', {
      method: 'POST',
      headers: {
        'api-key': process.env.BREVO_SMS_API_KEY,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: JSON.stringify({
        sender,
        recipient: to,
        content: body,
        type: 'transactional',
      }),
    });

    const data = await response.json();
    if (!response.ok) {
      if (data.message.includes('insufficient credits')) {
        throw new Error('Insufficient SMS credits. Please purchase credits at https://app.brevo.com/billing/addon/customize/sms');
      }
      throw new Error(data.message || 'Failed to send SMS');
    }
    console.log(`SMS sent to ${to}:`, data);
    return data;
  } catch (error) {
    console.error(`Error sending SMS to ${to}:`, error);
    throw new Error(`Failed to send SMS: ${error.message}`);
  }
};

export { sendSMS };