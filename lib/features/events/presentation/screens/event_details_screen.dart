import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/models/event_model.dart';
import '../../data/repositories/event_repository.dart';

class EventDetailsScreen extends ConsumerWidget {
  final String eventId;
  final EventModel? event;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    this.event,
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
              content: Text('Could not open WhatsApp for +$cleanNum'),
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

  void _shareEvent(EventModel item) {
    Share.share(
      'Join us at ${item.title}!\nDate: ${item.date} at ${item.time}\nLocation: ${item.location}\nOrganizer: ${item.organizer}\n\n${item.description}',
      subject: item.title,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = event != null
        ? AsyncData(event!)
        : ref.watch(eventByIdProvider(eventId));

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9), // Warm cream background
      body: SafeArea(
        child: eventAsync.when(
          data: (item) {
            if (item == null) {
              return const Center(child: Text('Event details not found'));
            }

            final img1 = item.images.isNotEmpty
                ? item.images[0]
                : 'https://images.unsplash.com/photo-1519741497674-611481863552?w=500';
            final img2 = item.images.length > 1 ? item.images[1] : img1;

            return Column(
              children: [
                // Top Header matching screenshot (< Event Title + subtitle)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            item.subtitle,
                            style: const TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2 Top Images
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

                        // INFO CARD (Date, Location, Time, Organizer) matching screenshot
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
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoItem(
                                      icon: Icons.calendar_today_outlined,
                                      label: 'DATE',
                                      value: item.date,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem(
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
                                    child: _buildInfoItem(
                                      icon: Icons.access_time_outlined,
                                      label: 'TIME',
                                      value: item.time,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildInfoItem(
                                      icon: Icons.person_outline,
                                      label: 'ORGANIZER',
                                      value: item.organizer,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // FULL DESCRIPTION SECTION matching screenshot
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFEBEBEB)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x06000000),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'A match made with tradition and love',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.description,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF444444),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Action Buttons: Register / Connect + Share
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
                                child: const Text(
                                  'Register Interest via WhatsApp',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => _shareEvent(item),
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
                                    ),
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
                        const SizedBox(height: 24),
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

  Widget _buildInfoItem({
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
