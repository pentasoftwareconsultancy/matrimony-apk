import axios from 'axios';

export const getCoordinates = async (address) => {
  const apiKey = process.env.GOOGLE_MAPS_API_KEY;
  const encodedAddress = encodeURIComponent(address);

  try {
    const response = await axios.get(apiKey);
    const data = response.data;

    if (data.status === 'OK' && data.results.length > 0) {
      const location = data.results[0].geometry.location;
      return { lat: location.lat, lng: location.lng };
    } else {
      console.error('Geocoding API error:', data.status);
      return null;
    }
  } catch (error) {
    console.error('Geocoding request failed:', error);
    return null;
  }
};


