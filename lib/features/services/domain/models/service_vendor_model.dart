class ServicePackageModel {
  final String title;
  final String price;

  const ServicePackageModel({
    required this.title,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'price': price,
      };

  factory ServicePackageModel.fromJson(Map<String, dynamic> json) => ServicePackageModel(
        title: json['title'] as String? ?? '',
        price: json['price'] as String? ?? '',
      );
}

class ServiceReviewModel {
  final String author;
  final String text;
  final double rating;
  final List<String> images;

  const ServiceReviewModel({
    required this.author,
    required this.text,
    this.rating = 5.0,
    this.images = const [],
  });

  Map<String, dynamic> toJson() => {
        'author': author,
        'text': text,
        'rating': rating,
        'images': images,
      };

  factory ServiceReviewModel.fromJson(Map<String, dynamic> json) => ServiceReviewModel(
        author: json['author'] as String? ?? 'Anonymous',
        text: json['text'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
        images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      );
}

class ServiceVendorModel {
  final String id;
  final String category; // 'photography', 'mehendi', 'decoration'
  final String name;
  final String subtitle;
  final String location;
  final double rating;
  final String projectCount;
  final String priceRange;
  final String phone;
  final String whatsappNumber;
  final List<String> images;
  final String about;
  final List<ServicePackageModel> packages;
  final List<String> specializations;
  final List<ServiceReviewModel> reviews;

  const ServiceVendorModel({
    required this.id,
    required this.category,
    required this.name,
    required this.subtitle,
    required this.location,
    required this.rating,
    required this.projectCount,
    required this.priceRange,
    required this.phone,
    required this.whatsappNumber,
    required this.images,
    required this.about,
    required this.packages,
    required this.specializations,
    required this.reviews,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'name': name,
        'subtitle': subtitle,
        'location': location,
        'rating': rating,
        'projectCount': projectCount,
        'priceRange': priceRange,
        'phone': phone,
        'whatsappNumber': whatsappNumber,
        'images': images,
        'about': about,
        'packages': packages.map((p) => p.toJson()).toList(),
        'specializations': specializations,
        'reviews': reviews.map((r) => r.toJson()).toList(),
      };

  factory ServiceVendorModel.fromJson(Map<String, dynamic> json) => ServiceVendorModel(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        category: json['category'] as String? ?? 'photography',
        name: json['name'] as String? ?? '',
        subtitle: json['subtitle'] as String? ?? '',
        location: json['location'] as String? ?? '',
        rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
        projectCount: json['projectCount'] as String? ?? '100+ projects',
        priceRange: json['priceRange'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        whatsappNumber: json['whatsappNumber'] as String? ?? json['phone'] as String? ?? '',
        images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        about: json['about'] as String? ?? '',
        packages: (json['packages'] as List<dynamic>?)
                ?.map((p) => ServicePackageModel.fromJson(p as Map<String, dynamic>))
                .toList() ??
            [],
        specializations:
            (json['specializations'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        reviews: (json['reviews'] as List<dynamic>?)
                ?.map((r) => ServiceReviewModel.fromJson(r as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
