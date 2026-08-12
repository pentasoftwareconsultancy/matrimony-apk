import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'vendor_list_screen.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
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
                  const Text(
                    'Services',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Services Categories List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _buildCategoryCard(
                    context: context,
                    title: 'Photography',
                    subtitle: 'Photographers, Cinematographers & Pre-wedding studios',
                    vendorCount: '6 vendors',
                    icon: Icons.camera_alt_outlined,
                    bgColor: const Color(0xFFF3E8FF),
                    textColor: const Color(0xFF8B5CF6),
                    categoryKey: 'photography',
                  ),
                  const SizedBox(height: 14),
                  _buildCategoryCard(
                    context: context,
                    title: 'Mehendi',
                    subtitle: 'Bridal Henna, Arabic & Traditional Mehendi Artists',
                    vendorCount: '4 vendors',
                    icon: Icons.back_hand_outlined,
                    bgColor: const Color(0xFFDCFCE7),
                    textColor: const Color(0xFF166534),
                    categoryKey: 'mehendi',
                  ),
                  const SizedBox(height: 14),
                  _buildCategoryCard(
                    context: context,
                    title: 'Decoration',
                    subtitle: 'Stage Setup, Mandap Decor, Floral & Theme Lighting',
                    vendorCount: '6 vendors',
                    icon: Icons.celebration_outlined,
                    bgColor: const Color(0xFFFCE7F3),
                    textColor: const Color(0xFFC9003F),
                    categoryKey: 'decoration',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String vendorCount,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required String categoryKey,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VendorListScreen(category: categoryKey),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEBEBEB)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: textColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          vendorCount,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFFCCCCCC), size: 14),
          ],
        ),
      ),
    );
  }
}
