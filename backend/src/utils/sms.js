import fetch from 'node-fetch';

export const sendSMS = async ({ phone, message }) => {
  const brevoApiKey = process.env.BREVO_SMS_API_KEY;

  if (!brevoApiKey) {
    console.warn(`[SMS MOCK] Target: ${phone} | Message: ${message}`);
    return { mock: true };
  }

  try {
    // Format phone number to international format if needed
    let formattedPhone = phone.trim();
    if (!formattedPhone.startsWith('+')) {
      formattedPhone = `+91${formattedPhone}`; // Default to India prefix if missing
    }

    const response = await fetch('https://api.brevo.com/v3/transactionalSMS/send', {
      method: 'POST',
      headers: {
        'api-key': brevoApiKey,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: JSON.stringify({
        sender: 'Matrimony',
        recipient: formattedPhone,
        content: message,
        type: 'transactional',
      }),
    });

    const data = await response.json();
    if (response.ok) {
      console.log(`[SMS SENT VIA BREVO] MessageId: ${data.messageId || 'OK'}`);
      return data;
    } else {
      console.error('[BREVO SMS ERROR]', data);
      return { error: true, data };
    }
  } catch (err) {
    console.error('[SMS SEND EXCEPTION]', err.message);
    return { error: true, message: err.message };
  }
};
