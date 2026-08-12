import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/models/service_vendor_model.dart';
import '../../data/repositories/service_repository.dart';

class ServiceDetailsScreen extends ConsumerWidget {
  final String vendorId;
  final ServiceVendorModel? vendor;

  const ServiceDetailsScreen({
    super.key,
    required this.vendorId,
    this.vendor,
  });

  Future<void> _launchWhatsApp(BuildContext context, String number) async {
    final cleanNum = number.replaceAll(RegExp(r'\D'), '');
    final Uri uri = Uri.parse('https://wa.me/$cleanNum');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch WhatsApp for +$cleanNum'),
              backgroundColor: const Color(0xFFC9003F),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('WhatsApp unavailable: $e'),
            backgroundColor: const Color(0xFFC9003F),
          ),
        );
      }
    }
  }

  void _shareVendor(ServiceVendorModel item) {
    Share.share(
      'Check out ${item.name} (${item.subtitle}) on Matrimony App!\nLocation: ${item.location}\nProjects: ${item.projectCount}\nPrice Range: ${item.priceRange}\nPhone: ${item.phone}',
      subject: item.name,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorAsync = vendor != null
        ? AsyncData(vendor!)
        : ref.watch(vendorByIdProvider(vendorId));

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9), // Warm cream background
      body: SafeArea(
        child: vendorAsync.when(
          data: (item) {
            if (item == null) {
              return const Center(child: Text('Vendor details not found'));
            }

            final img1 = item.images.isNotEmpty
                ? item.images[0]
                : 'https://images.unsplash.com/photo-1519741497674-611481863552?w=500';
            final img2 = item.images.length > 1 ? item.images[1] : img1;

            return Column(
              children: [
                // HEADER matching reference (< Vendor Name + subtitle + Connect red pill)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (item.subtitle.isNotEmpty)
                                Text(
                                  item.subtitle,
                                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                                ),
                            ],
                          ),
                        ],
                      ),

                      // Connect button top right
                      ElevatedButton(
                        onPressed: () => _launchWhatsApp(context, item.whatsappNumber),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC9003F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(80, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Connect',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

                // SCROLLABLE CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Gallery (2 Images)
                        SizedBox(
                          height: 160,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: CachedNetworkImage(
                                    imageUrl: img1,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: CachedNetworkImage(
                                    imageUrl: img2,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // INFO CARD (Studio, Location, Projects, Phone) matching screenshot
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFEBEBEB)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x06000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoGridItem(
                                      icon: Icons.storefront_outlined,
                                      label: 'STUDIO',
                                      value: item.subtitle.isNotEmpty ? item.subtitle : item.name,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoGridItem(
                                      icon: Icons.location_on_outlined,
                                      label: 'LOCATION',
                                      value: item.location,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoGridItem(
                                      icon: Icons.work_outline,
                                      label: 'PROJECTS',
                                      value: item.projectCount,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoGridItem(
                                      icon: Icons.phone_outlined,
                                      label: 'PHONE',
                                      value: item.phone,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ABOUT ME SECTION
                        if (item.about.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFEBEBEB)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x06000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'About me',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.about,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF555555),
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // PRICING PACKAGES
                        if (item.packages.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFEBEBEB)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x06000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Text('💰 ', style: TextStyle(fontSize: 12)),
                                    Text(
                                      'Pricing packages',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ...List.generate(item.packages.length, (idx) {
                                  final pkg = item.packages[idx];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFDCFCE7),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '${idx + 1}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF166534),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          pkg.title,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // SPECIALIZATIONS
                        if (item.specializations.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: const Color(0xFFEBEBEB)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x06000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Text('✨ ', style: TextStyle(fontSize: 12)),
                                    Text(
                                      'Specializations',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ...item.specializations.map(
                                  (spec) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6.0),
                                    child: Row(
                                      children: [
                                        const Text('• ',
                                            style: TextStyle(
                                                color: Color(0xFFC9003F),
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          spec,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF444444),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // MAIN CONNECT BUTTON + SHARE ICON matching screenshot
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _launchWhatsApp(context, item.whatsappNumber),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC9003F),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Connect with ${item.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => _shareVendor(item),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFEBEBEB)),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x0A000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.ios_share,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // REVIEWS SECTION matching screenshot
                        if (item.reviews.isNotEmpty) ...[
                          const Row(
                            children: [
                              Text('⭐ ', style: TextStyle(fontSize: 13)),
                              Text(
                                'Reviews',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: item.reviews.map((rev) {
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFEBEBEB)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rev.author,
                                        style: const TextStyle(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        rev.text,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 9.5,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: List.generate(
                                          5,
                                          (i) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 11,
                                          ),
                                        ),
                                      ),
                                      if (rev.images.isNotEmpty) ...[
                                        const SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            imageUrl: rev.images.first,
                                            height: 60,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFFC9003F)),
          ),
          error: (err, stack) => Center(
            child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoGridItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade700),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 8.5, color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
