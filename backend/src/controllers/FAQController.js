import FAQ from '../models/FAQ.js';
import { ApiResponse } from '../utils/apiResponse.js';

class FAQController {
  async getFAQs(req, res, next) {
    try {
      const faqs = await FAQ.find().lean();
      const list = faqs.map(f => ({
        id: f._id.toString(),
        question: f.question,
        answer: f.answer,
        category: f.category || 'General',
      }));
      return ApiResponse.success(res, 'FAQs retrieved', list, 200);
    } catch (error) {
      next(error);
    }
  }
}

export default new FAQController();
