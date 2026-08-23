import Testimonial from '../models/Testimonial.js';
import { ApiResponse } from '../utils/apiResponse.js';

class TestimonialController {
  async getTestimonials(req, res, next) {
    try {
      const testimonials = await Testimonial.find({ isActive: true }).lean();
      const list = testimonials.map(t => ({
        ...t,
        id: t._id.toString(),
      }));
      return ApiResponse.success(res, 'Testimonials retrieved', list, 200);
    } catch (error) {
      next(error);
    }
  }
}

export default new TestimonialController();
