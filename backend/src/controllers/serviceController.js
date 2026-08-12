import ServiceVendor from '../models/ServiceVendor.js';

// GET all service vendors (optional category filter)
export const getVendors = async (req, res, next) => {
  try {
    const { category } = req.query;
    const filter = { isActive: true };
    if (category) {
      filter.category = category.toLowerCase();
    }
    const vendors = await ServiceVendor.find(filter).sort({ rating: -1 });
    res.status(200).json({ success: true, count: vendors.length, data: vendors });
  } catch (error) {
    next(error);
  }
};

// GET vendor by ID
export const getVendorById = async (req, res, next) => {
  try {
    const vendor = await ServiceVendor.findById(req.params.id);
    if (!vendor) {
      return res.status(404).json({ success: false, message: 'Vendor not found' });
    }
    res.status(200).json({ success: true, data: vendor });
  } catch (error) {
    next(error);
  }
};

// ADMIN: Create vendor
export const createVendor = async (req, res, next) => {
  try {
    const vendor = await ServiceVendor.create(req.body);
    res.status(201).json({ success: true, data: vendor });
  } catch (error) {
    next(error);
  }
};

// ADMIN: Update vendor
export const updateVendor = async (req, res, next) => {
  try {
    const vendor = await ServiceVendor.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!vendor) {
      return res.status(404).json({ success: false, message: 'Vendor not found' });
    }
    res.status(200).json({ success: true, data: vendor });
  } catch (error) {
    next(error);
  }
};

// ADMIN: Delete vendor
export const deleteVendor = async (req, res, next) => {
  try {
    const vendor = await ServiceVendor.findByIdAndDelete(req.params.id);
    if (!vendor) {
      return res.status(404).json({ success: false, message: 'Vendor not found' });
    }
    res.status(200).json({ success: true, message: 'Vendor deleted successfully' });
  } catch (error) {
    next(error);
  }
};
