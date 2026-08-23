import {
  Photographer,
  Decoration,
  Mehendi,
  Jewellery,
  Makeup,
  Lighting,
  DJMusic
} from '../models/Vendors.js';

const categoryModelMap = {
  photographer: Photographer,
  photography: Photographer,
  photographers: Photographer,
  decoration: Decoration,
  decorations: Decoration,
  mehndi: Mehendi,
  mehendi: Mehendi,
  jewellery: Jewellery,
  jewelry: Jewellery,
  makeup: Makeup,
  lighting: Lighting,
  djmusic: DJMusic,
  dj: DJMusic,
};

// GET all service vendors
export const getVendors = async (req, res, next) => {
  try {
    const { category } = req.query;
    let vendors = [];

    if (category) {
      const catKey = category.toLowerCase().trim();
      const Model = categoryModelMap[catKey];
      if (Model) {
        vendors = await Model.find().lean();
        vendors = vendors.map(v => ({ ...v, category: catKey }));
      } else {
        vendors = [];
      }
    } else {
      // Aggregate across all vendor collections
      const p = await Photographer.find().lean();
      const d = await Decoration.find().lean();
      const m = await Mehendi.find().lean();
      const j = await Jewellery.find().lean();
      const mk = await Makeup.find().lean();
      const l = await Lighting.find().lean();
      const dj = await DJMusic.find().lean();

      vendors = [
        ...p.map(item => ({ ...item, category: 'photographer' })),
        ...d.map(item => ({ ...item, category: 'decoration' })),
        ...m.map(item => ({ ...item, category: 'mehndi' })),
        ...j.map(item => ({ ...item, category: 'jewellery' })),
        ...mk.map(item => ({ ...item, category: 'makeup' })),
        ...l.map(item => ({ ...item, category: 'lighting' })),
        ...dj.map(item => ({ ...item, category: 'djmusic' })),
      ];
    }

    res.status(200).json({ success: true, count: vendors.length, data: vendors });
  } catch (error) {
    next(error);
  }
};

// GET vendor by ID
export const getVendorById = async (req, res, next) => {
  try {
    const id = req.params.id;
    const models = [Photographer, Decoration, Mehendi, Jewellery, Makeup, Lighting, DJMusic];

    for (const Model of models) {
      const vendor = await Model.findById(id).lean();
      if (vendor) {
        return res.status(200).json({ success: true, data: vendor });
      }
    }

    return res.status(404).json({ success: false, message: 'Vendor not found' });
  } catch (error) {
    next(error);
  }
};

export const createVendor = async (req, res, next) => {
  try {
    return res.status(400).json({ success: false, message: 'Vendor creation is managed via Website Admin Panel' });
  } catch (error) {
    next(error);
  }
};

export const updateVendor = async (req, res, next) => {
  try {
    return res.status(400).json({ success: false, message: 'Vendor updates are managed via Website Admin Panel' });
  } catch (error) {
    next(error);
  }
};

export const deleteVendor = async (req, res, next) => {
  try {
    return res.status(400).json({ success: false, message: 'Vendor deletion is managed via Website Admin Panel' });
  } catch (error) {
    next(error);
  }
};
