import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/repositories/service_repository.dart';
import '../../domain/models/service_vendor_model.dart';
import 'service_details_screen.dart';

class VendorListScreen extends ConsumerWidget {
  final String category; // 'photography', 'mehendi', 'decoration'

  const VendorListScreen({
    super.key,
    required this.category,
  });

  String get _displayTitle {
    switch (category.toLowerCase()) {
      case 'photography':
        return 'Photography';
      case 'mehendi':
        return 'Mehendi';
      case 'decoration':
        return 'Decoration';
      default:
        return category;
    }
  }

  Color get _badgeBgColor {
    switch (category.toLowerCase()) {
      case 'photography':
        return const Color(0xFFF3E8FF);
      case 'mehendi':
        return const Color(0xFFDCFCE7);
      case 'decoration':
        return const Color(0xFFFCE7F3);
      default:
        return const Color(0xFFFCE7F3);
    }
  }

  Color get _badgeTextColor {
    switch (category.toLowerCase()) {
      case 'photography':
        return const Color(0xFF8B5CF6);
      case 'mehendi':
        return const Color(0xFF166534);
      case 'decoration':
        return const Color(0xFFC9003F);
      default:
        return const Color(0xFFC9003F);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorsAsync = ref.watch(servicesByCategoryProvider(category));

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9), // Warm cream background
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.arrow_back, color: Colors.black87, size: 22),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _displayTitle,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Vendor count badge
                  vendorsAsync.when(
                    data: (vendors) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _badgeBgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${vendors.length} vendors',
                        style: TextStyle(
                          color: _badgeTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // Vendor Grid
            Expanded(
              child: vendorsAsync.when(
                data: (vendors) {
                  if (vendors.isEmpty) {
                    return const Center(
                      child: Text(
                        'No vendors found in this category',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: vendors.length,
                    itemBuilder: (context, index) {
                      final vendor = vendors[index];
                      return _buildVendorCard(context, vendor);
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFFC9003F)),
                ),
                error: (err, stack) => Center(
                  child: Text(
                    'Failed to load vendors: $err',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorCard(BuildContext context, ServiceVendorModel vendor) {
    final img1 = vendor.images.isNotEmpty
        ? vendor.images[0]
        : 'https://images.unsplash.com/photo-1519741497674-611481863552?w=500';
    final img2 = vendor.images.length > 1
        ? vendor.images[1]
        : img1;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailsScreen(vendorId: vendor.id, vendor: vendor),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEBEBEB)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Vendor Name + Star Rating Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      vendor.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF2F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 11),
                        const SizedBox(width: 2),
                        Text(
                          vendor.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFBE185D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),

              // Subtitle
              Text(
                vendor.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 3),

              // Location
              Row(
                children: [
                  const Icon(Icons.location_on, size: 10, color: Color(0xFFC9003F)),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      vendor.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 9.5, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),

              // Project count
              Text(
                vendor.projectCount,
                style: const TextStyle(fontSize: 9.5, color: Colors.grey),
              ),
              const SizedBox(height: 4),

              // Price range
              Text(
                vendor.priceRange,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(height: 8),

              // 2 Showcase Images Side by Side
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: img1,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          placeholder: (context, url) => Container(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: img2,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          placeholder: (context, url) => Container(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
