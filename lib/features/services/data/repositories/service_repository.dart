import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/service_vendor_model.dart';

final serviceRepositoryProvider = Provider<ServiceRepository>((ref) {
  return ServiceRepository();
});

final servicesByCategoryProvider =
    FutureProvider.family<List<ServiceVendorModel>, String>((ref, category) async {
  final repo = ref.watch(serviceRepositoryProvider);
  return repo.getVendorsByCategory(category);
});

final vendorByIdProvider =
    FutureProvider.family<ServiceVendorModel?, String>((ref, vendorId) async {
  final repo = ref.watch(serviceRepositoryProvider);
  return repo.getVendorById(vendorId);
});

class ServiceRepository {
  // Reference static initial vendors matching exact prompt & screenshot specs
  static final List<ServiceVendorModel> _initialVendors = [
    // PHOTOGRAPHY
    const ServiceVendorModel(
      id: 'photo_1',
      category: 'photography',
      name: 'Shubham',
      subtitle: 'Shubham Digital',
      location: 'Akola, MH',
      rating: 4.9,
      projectCount: '300+ projects',
      priceRange: '₹40K - 80K',
      phone: '9856543232',
      whatsappNumber: '919856543232',
      images: [
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
      ],
      about:
          'The wedding of Priya & Rahul was nothing short of a fairytale — a vibrant celebration where modern love met timeless traditions. Held at the Taj Krishna in Hyderabad on a golden December evening, the festivities began with a Sangeet night where both families danced to Bollywood hits and Telugu folk songs. The Mehndi ceremony the next day transformed the courtyard into an aromatic paradise, with intricate henna designs mirroring the couple\'s journey — a delicate fusion of Rahul\'s Punjabi roots and Priya\'s Telugu heritage.',
      packages: [
        ServicePackageModel(title: '50K — 8 hours', price: '₹50,000'),
        ServicePackageModel(title: '80K — Full day', price: '₹80,000'),
        ServicePackageModel(title: '1L — Two days', price: '₹100,000'),
      ],
      specializations: [
        'Candid photography',
        'Pre-wedding photography',
        'Live Instagram reel coverage',
      ],
      reviews: [
        ServiceReviewModel(
          author: 'Review',
          text:
              'Shubham Photography is one of the best photographers we have ever met. Truly',
          rating: 5.0,
          images: ['https://images.unsplash.com/photo-1519741497674-611481863552?w=500'],
        ),
        ServiceReviewModel(
          author: 'Review',
          text:
              'Brilliant captures — every moment was framed beautifully. Highly recommend',
          rating: 5.0,
          images: ['https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500'],
        ),
      ],
    ),
    const ServiceVendorModel(
      id: 'photo_2',
      category: 'photography',
      name: 'Sunil Kale',
      subtitle: 'Photogenic Studio',
      location: 'Akola, MH',
      rating: 4.8,
      projectCount: '300+ projects',
      priceRange: '₹35K - 70K',
      phone: '9876543210',
      whatsappNumber: '919876543210',
      images: [
        'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=500',
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
      ],
      about:
          'Photogenic Studio by Sunil Kale specializes in high-end candid moments, cinematic wedding films, and traditional portraiture with 10+ years of experience across Maharashtra.',
      packages: [
        ServicePackageModel(title: '35K — Standard package', price: '₹35,000'),
        ServicePackageModel(title: '70K — Cinematic premium package', price: '₹70,000'),
      ],
      specializations: ['Traditional wedding photography', 'Cinematic video teaser'],
      reviews: [
        ServiceReviewModel(
          author: 'Review',
          text: 'Great work and extremely professional team!',
          rating: 4.8,
          images: ['https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=500'],
        ),
      ],
    ),
    const ServiceVendorModel(
      id: 'photo_3',
      category: 'photography',
      name: 'Rohit Arts',
      subtitle: 'Rohit Photography',
      location: 'Nagpur, MH',
      rating: 4.7,
      projectCount: '150+ projects',
      priceRange: '₹20K - 60K',
      phone: '9856712340',
      whatsappNumber: '919856712340',
      images: [
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
        'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=500',
      ],
      about:
          'Rohit Arts brings artistic framing, outdoor shoot expertise, and modern color grading to every wedding event.',
      packages: [
        ServicePackageModel(title: '20K — Single event', price: '₹20,000'),
        ServicePackageModel(title: '60K — Complete wedding shoot', price: '₹60,000'),
      ],
      specializations: ['Outdoor pre-wedding', 'Drone cinematography'],
      reviews: [],
    ),
    const ServiceVendorModel(
      id: 'photo_4',
      category: 'photography',
      name: 'Nikhil Frames',
      subtitle: 'Nikhil Captures',
      location: 'Pune, MH',
      rating: 4.8,
      projectCount: '200+ projects',
      priceRange: '₹45K - 90K',
      phone: '9765432109',
      whatsappNumber: '919765432109',
      images: [
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
      ],
      about:
          'Nikhil Captures is renowned for storytelling wedding photography, capturing raw emotion, candid joy, and family celebrations.',
      packages: [
        ServicePackageModel(title: '45K — 1 Day Candid', price: '₹45,000'),
        ServicePackageModel(title: '90K — 2 Day Full Coverage', price: '₹90,000'),
      ],
      specializations: ['Storyteller wedding albums', 'Live streaming'],
      reviews: [],
    ),
    const ServiceVendorModel(
      id: 'photo_5',
      category: 'photography',
      name: 'Arjun Lens',
      subtitle: 'Arjun Studios',
      location: 'Mumbai, MH',
      rating: 5.0,
      projectCount: '500+ projects',
      priceRange: '₹80K - 1.2L',
      phone: '9820011223',
      whatsappNumber: '919820011223',
      images: [
        'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=500',
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
      ],
      about:
          'Arjun Studios is a premium celebrity wedding photography firm based out of Mumbai with extensive experience in luxury weddings across India.',
      packages: [
        ServicePackageModel(title: '80K — Standard wedding', price: '₹80,000'),
        ServicePackageModel(title: '1.2L — Luxury destination package', price: '₹120,000'),
      ],
      specializations: ['Destination weddings', 'High-end photo albums'],
      reviews: [],
    ),
    const ServiceVendorModel(
      id: 'photo_6',
      category: 'photography',
      name: 'Priya Clicks',
      subtitle: 'Priya Moments',
      location: 'Nashik, MH',
      rating: 4.6,
      projectCount: '120+ projects',
      priceRange: '₹25K - 50K',
      phone: '9988776655',
      whatsappNumber: '919988776655',
      images: [
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
        'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=500',
      ],
      about:
          'Priya Moments captures intimate family portraits, vibrant Haldi & Sangeet moments with vibrant natural colors.',
      packages: [
        ServicePackageModel(title: '25K — Basic package', price: '₹25,000'),
        ServicePackageModel(title: '50K — Full wedding package', price: '₹50,000'),
      ],
      specializations: ['Haldi & Sangeet specialist', 'Custom photobooks'],
      reviews: [],
    ),

    // MEHENDI
    const ServiceVendorModel(
      id: 'mehendi_1',
      category: 'mehendi',
      name: 'Sneha',
      subtitle: 'Sneha mehendi',
      location: 'Akola, MH',
      rating: 4.8,
      projectCount: '500+ projects',
      priceRange: '₹10K - 20K',
      phone: '9876541230',
      whatsappNumber: '919876541230',
      images: [
        'https://images.unsplash.com/photo-1563178406-4cdc2923acbc?w=500',
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
      ],
      about:
          'The Mehndi ceremony transformed the courtyard into an aromatic paradise, with intricate henna designs mirroring the couple\'s journey — a delicate fusion of Punjabi roots and Telugu heritage. Sneha brings 10+ years of artistry and a signature style that weaves modern motifs with timeless bridal patterns, making every bride\'s hands a canvas of memories.',
      packages: [
        ServicePackageModel(title: '10K — Two hands', price: '₹10,000'),
        ServicePackageModel(title: '20K — Hands and legs', price: '₹20,000'),
      ],
      specializations: [
        'Arabic',
        'Indian traditional',
        'Bridal torso art',
      ],
      reviews: [
        ServiceReviewModel(
          author: 'Review',
          text:
              'Sneha\'s mehendi work was absolutely stunning! The bridal design stayed for 3 weeks.',
          rating: 5.0,
          images: ['https://images.unsplash.com/photo-1563178406-4cdc2923acbc?w=500'],
        ),
        ServiceReviewModel(
          author: 'Review',
          text:
              'The Arabic patterns she created were so intricate and beautiful. Everyone at the',
          rating: 5.0,
          images: ['https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500'],
        ),
      ],
    ),
    const ServiceVendorModel(
      id: 'mehendi_2',
      category: 'mehendi',
      name: 'Kajal Designs',
      subtitle: 'Kajal Mehendi Art',
      location: 'Nagpur, MH',
      rating: 4.7,
      projectCount: '300+ projects',
      priceRange: '₹4K - 12K',
      phone: '9823456789',
      whatsappNumber: '919823456789',
      images: [
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
        'https://images.unsplash.com/photo-1563178406-4cdc2923acbc?w=500',
      ],
      about:
          'Kajal Mehendi Art specializes in organic henna, modern minimalist Arabic mehendi, and quick guest henna packages.',
      packages: [
        ServicePackageModel(title: '4K — Basic bridal hands', price: '₹4,000'),
        ServicePackageModel(title: '12K — Full bridal package', price: '₹12,000'),
      ],
      specializations: ['Organic Henna', 'Minimalist Arabic'],
      reviews: [],
    ),
    const ServiceVendorModel(
      id: 'mehendi_3',
      category: 'mehendi',
      name: 'Sunita Kala',
      subtitle: 'Sunita Henna',
      location: 'Pune, MH',
      rating: 4.8,
      projectCount: '200+ projects',
      priceRange: '₹8K - 18K',
      phone: '9811223344',
      whatsappNumber: '919811223344',
      images: [
        'https://images.unsplash.com/photo-1563178406-4cdc2923acbc?w=500',
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
      ],
      about:
          'Sunita Henna offers traditional Marwari & Rajasthani mehendi figures, portrait mehendi, and custom love story motifs.',
      packages: [
        ServicePackageModel(title: '8K — Bridal hands', price: '₹8,000'),
        ServicePackageModel(title: '18K — Royal Marwari bridal package', price: '₹18,000'),
      ],
      specializations: ['Marwari figures', 'Portrait Mehendi'],
      reviews: [],
    ),
    const ServiceVendorModel(
      id: 'mehendi_4',
      category: 'mehendi',
      name: 'Priya Mehendi',
      subtitle: 'Priya Henna Art',
      location: 'Mumbai, MH',
      rating: 5.0,
      projectCount: '800+ projects',
      priceRange: '₹8K - 25K',
      phone: '9769012345',
      whatsappNumber: '919769012345',
      images: [
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
        'https://images.unsplash.com/photo-1563178406-4cdc2923acbc?w=500',
      ],
      about:
          'Priya Henna Art is a celebrated celebrity mehendi artist based in Mumbai, known for ultra-dark stain formula and intricate symmetrical art.',
      packages: [
        ServicePackageModel(title: '8K — Simple bridal', price: '₹8,000'),
        ServicePackageModel(title: '25K — Celebrity bridal package', price: '₹25,000'),
      ],
      specializations: ['Symmetrical bridal art', 'Dark stain organic cone'],
      reviews: [],
    ),

    // DECORATION
    const ServiceVendorModel(
      id: 'decor_1',
      category: 'decoration',
      name: 'Elite Decorations',
      subtitle: 'Elite decor',
      location: 'Akola, MH',
      rating: 4.9,
      projectCount: '300+ projects',
      priceRange: '₹50K - 2L',
      phone: '9765000099',
      whatsappNumber: '919765000099',
      images: [
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
      ],
      about:
          'Sneha Decorations has been transforming wedding venues into dream destinations for over 12 years. From grand mandap setups adorned with fresh flowers to dramatic stage backdrops with draped fabrics and fairy lights, every setup is crafted with precision and passion. We serve all of Vidarbha and beyond, bringing elegance to weddings, receptions, and all related ceremonies.',
      packages: [
        ServicePackageModel(title: '50K — Basic setup', price: '₹50,000'),
        ServicePackageModel(title: '1L — Full venue decoration', price: '₹100,000'),
        ServicePackageModel(title: '2L — Premium theme package', price: '₹200,000'),
      ],
      specializations: [
        'Floral stage decoration',
        'Theme-based wedding setup',
      ],
      reviews: [
        ServiceReviewModel(
          author: 'Review',
          text:
              'Sneha Decorations transformed our venue completely — it looked like a fairytale.',
          rating: 5.0,
          images: ['https://images.unsplash.com/photo-1519741497674-611481863552?w=500'],
        ),
        ServiceReviewModel(
          author: 'Review',
          text:
              'The floral stage was breathtaking. They executed the theme perfectly and on time.',
          rating: 5.0,
          images: ['https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500'],
        ),
      ],
    ),
    const ServiceVendorModel(
      id: 'decor_2',
      category: 'decoration',
      name: 'Shubham',
      subtitle: 'Sneha Decorations',
      location: 'Akola, MH',
      rating: 4.8,
      projectCount: '300+ projects',
      priceRange: '₹50K - 2L',
      phone: '9856543232',
      whatsappNumber: '919856543232',
      images: [
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
      ],
      about:
          'Shubham Decoration unit delivers traditional royal mandaps, entryway floral arches, and warm lighting aesthetics for weddings and Sangeet venues.',
      packages: [
        ServicePackageModel(title: '50K — Mandap setup', price: '₹50,000'),
        ServicePackageModel(title: '2L — Complete venue decoration', price: '₹200,000'),
      ],
      specializations: ['Royal Mandap', 'Entrance floral arch'],
      reviews: [],
    ),
    const ServiceVendorModel(
      id: 'decor_3',
      category: 'decoration',
      name: 'Sunil Kale',
      subtitle: 'Sneha Decorations',
      location: 'Akola, MH',
      rating: 4.8,
      projectCount: '300+ projects',
      priceRange: '₹50K - 2L',
      phone: '9876543210',
      whatsappNumber: '919876543210',
      images: [
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
      ],
      about:
          'Expertise in eco-friendly floral decorations, beach/lake view mandaps, and LED truss stage lighting.',
      packages: [
        ServicePackageModel(title: '50K — Basic floral', price: '₹50,000'),
        ServicePackageModel(title: '2L — Luxury LED & Floral', price: '₹200,000'),
      ],
      specializations: ['Eco-friendly flowers', 'LED Truss lightings'],
      reviews: [],
    ),
    const ServiceVendorModel(
      id: 'decor_4',
      category: 'decoration',
      name: 'Rajesh Decors',
      subtitle: 'Rajesh Events',
      location: 'Nagpur, MH',
      rating: 4.7,
      projectCount: '150+ projects',
      priceRange: '₹40K - 1.5L',
      phone: '9822334455',
      whatsappNumber: '919822334455',
      images: [
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
      ],
      about:
          'Rajesh Events offers end-to-end wedding hall decor, passage lighting, Haldi yellow flower concepts, and custom mandap structures.',
      packages: [
        ServicePackageModel(title: '40K — Haldi decor', price: '₹40,000'),
        ServicePackageModel(title: '1.5L — Grand wedding decor', price: '₹150,000'),
      ],
      specializations: ['Yellow Haldi theme', 'Passage fairy lights'],
      reviews: [],
    ),
    const ServiceVendorModel(
      id: 'decor_5',
      category: 'decoration',
      name: 'Priya Setups',
      subtitle: 'Priya Decorations',
      location: 'Pune, MH',
      rating: 4.8,
      projectCount: '250+ projects',
      priceRange: '₹80K - 2.5L',
      phone: '9890123456',
      whatsappNumber: '919890123456',
      images: [
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
      ],
      about:
          'Priya Setups specializes in modern pastel wedding themes, crystal chandeliers, glass mandaps, and mirror aisles.',
      packages: [
        ServicePackageModel(title: '80K — Pastel stage', price: '₹80,000'),
        ServicePackageModel(title: '2.5L — Crystal luxury theme', price: '₹250,000'),
      ],
      specializations: ['Pastel theme', 'Crystal chandelier setup'],
      reviews: [],
    ),
    const ServiceVendorModel(
      id: 'decor_6',
      category: 'decoration',
      name: 'Royal Blooms',
      subtitle: 'Royal Floral Decor',
      location: 'Amravati, MH',
      rating: 4.6,
      projectCount: '120+ projects',
      priceRange: '₹35K - 1.2L',
      phone: '9766554433',
      whatsappNumber: '919766554433',
      images: [
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
      ],
      about:
          'Royal Floral Decor provides exotic orchid & rose stage decorations, carpeted mandaps, and entrance archways.',
      packages: [
        ServicePackageModel(title: '35K — Floral stage', price: '₹35,000'),
        ServicePackageModel(title: '1.2L — Full venue floral package', price: '₹120,000'),
      ],
      specializations: ['Exotic orchid stages', 'Carpeted mandaps'],
      reviews: [],
    ),
  ];

  Future<List<ServiceVendorModel>> getVendorsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final cat = category.toLowerCase();
    return _initialVendors.where((v) => v.category.toLowerCase() == cat).toList();
  }

  Future<ServiceVendorModel?> getVendorById(String vendorId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _initialVendors.firstWhere((v) => v.id == vendorId);
    } catch (_) {
      return _initialVendors.first;
    }
  }
}
