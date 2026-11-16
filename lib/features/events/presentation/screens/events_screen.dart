import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repositories/event_repository.dart';
import '../../domain/models/event_model.dart';
import 'event_details_screen.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  Future<void> _launchWhatsApp(BuildContext context, String number) async {
    final cleanNum = number.replaceAll(RegExp(r'\D'), '');
    final Uri uri = Uri.parse('https://wa.me/$cleanNum');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FA), // Soft blush-white background
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top App Bar Header matching screenshot
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
                      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Icon(Icons.arrow_back, color: Color(0xFF1F1F1F), size: 24),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Events',
                        style: TextStyle(
                          color: Color(0xFFC0003E),
                          fontSize: 26,
                          fontFamily: 'serif',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Where Hearts Meet Happily!',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFFC0003E),
                onRefresh: () async {
                  try {
                    ref.invalidate(eventsProvider);
                    await ref.read(eventsProvider.future);
                  } catch (_) {}
                },
                child: eventsAsync.when(
                  data: (events) {
                    final upcoming = events.where((e) => e.isUpcoming).toList()
                      ..sort((a, b) => a.compareByDate(b));

                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 2. Large Promotional Banner matching reference screenshot
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFF1F4),
                                  Color(0xFFFFE7ED),
                                  Color(0xFFFFDFE8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFFFCDD7), width: 1.0),
                            ),
                            padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 12,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '“Where Hearts\nMeet Happily!”',
                                        style: TextStyle(
                                          color: Color(0xFF9E0B38),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'serif',
                                          height: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Join our exclusive matchmaking events — a beautiful blend of tradition and modern connections.',
                                        style: TextStyle(
                                          color: Color(0xFF555555),
                                          fontSize: 11.5,
                                          height: 1.35,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        width: 44,
                                        height: 3.5,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFC0003E),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 9,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: (upcoming.isNotEmpty &&
                                                upcoming.first.images.isNotEmpty &&
                                                !upcoming.first.images.first.contains('unsplash.com'))
                                            ? Image.network(
                                                upcoming.first.images.first,
                                                height: 110,
                                                width: 125,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                                  'assets/images/heart.png',
                                                  height: 90,
                                                  width: 100,
                                                  fit: BoxFit.contain,
                                                ),
                                              )
                                            : Image.asset(
                                                'assets/images/heart.png',
                                                height: 90,
                                                width: 100,
                                                fit: BoxFit.contain,
                                              ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 4,
                                        child: CustomPaint(
                                          size: const Size(36, 32),
                                          painter: _FloatingHeartPainter(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),

                          // 3. UPCOMING EVENTS Heading & Count Badge
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'UPCOMING EVENTS',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A4A4A),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFEBF0),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  '${upcoming.length} ${upcoming.length == 1 ? 'event' : 'events'}',
                                  style: const TextStyle(
                                    color: Color(0xFFC0003E),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // 4. Upcoming events list or empty state
                          if (upcoming.isEmpty)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF9FA),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFFFDEE7)),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.event_busy_outlined,
                                    color: Color(0xFFC0003E),
                                    size: 34,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'No upcoming events right now',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Please check back soon for upcoming matchmaking events.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.grey,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: upcoming.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 14),
                              itemBuilder: (context, index) =>
                                  _buildUpcomingCard(context, upcoming[index]),
                            ),
                          const SizedBox(height: 24),

                          // 5. Bottom Register for next event banner
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A0812), // Dark burgundy / maroon container
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Register for next event',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'events@matrimony.com',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Color(0xFFB0A4A8), fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: (upcoming.isNotEmpty && upcoming.first.whatsappNumber.isNotEmpty)
                                      ? () => _launchWhatsApp(context, upcoming.first.whatsappNumber)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC0003E),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    minimumSize: const Size(80, 34),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Contact us',
                                    style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Color(0xFFC0003E)),
                  ),
                  error: (err, stack) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: 400,
                      child: Center(
                        child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Event Card matching reference screenshot
  Widget _buildUpcomingCard(BuildContext context, EventModel event) {
    final dayNum = event.displayDay;
    final monthYear = event.displayMonthYear;
    final imageUrl = event.images.isNotEmpty ? event.images.first : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsScreen(eventId: event.id, event: event),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9FA), // Soft blush pink card background
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFFDEE7), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC0003E).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left: Event Image with overlaid Date Badge
              SizedBox(
                width: 118,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (imageUrl.isNotEmpty)
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: const Color(0xFFFFE6ED),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.celebration_rounded,
                              color: Color(0xFFC0003E),
                              size: 38,
                            ),
                          ),
                        )
                      else
                        Container(
                          color: const Color(0xFFFFE6ED),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.celebration_rounded,
                            color: Color(0xFFC0003E),
                            size: 38,
                          ),
                        ),
                      // Date Badge in Upper-Left
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFC0003E),
                                Color(0xFF8F002A),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                dayNum,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.05,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                monthYear,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w600,
                                  height: 1.05,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Right: Details (SOON badge, Title, Description, Register Interest button)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SOON badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC0003E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            event.badgeText.isNotEmpty ? event.badgeText : 'SOON',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Event Title
                        Text(
                          event.title.isNotEmpty ? event.title : event.subtitle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E1E1E),
                            height: 1.25,
                          ),
                        ),
                        // Event Description
                        if (event.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            event.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Pink REGISTER INTEREST -> button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE8EF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'REGISTER INTEREST',
                              style: TextStyle(
                                color: Color(0xFFC0003E),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFFC0003E),
                              size: 14,
                            ),
                          ],
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

/// Hand-drawn style decorative floating pink heart outline
class _FloatingHeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC0003E).withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // Continuous line heart path
    path.moveTo(size.width * 0.1, size.height * 0.95);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.85, size.width * 0.5, size.height * 0.95);
    path.cubicTo(
      size.width * 0.15, size.height * 0.65,
      size.width * 0.05, size.height * 0.25,
      size.width * 0.35, size.height * 0.15,
    );
    path.cubicTo(
      size.width * 0.5, size.height * 0.1,
      size.width * 0.5, size.height * 0.3,
      size.width * 0.5, size.height * 0.35,
    );
    path.cubicTo(
      size.width * 0.5, size.height * 0.3,
      size.width * 0.5, size.height * 0.1,
      size.width * 0.65, size.height * 0.15,
    );
    path.cubicTo(
      size.width * 0.95, size.height * 0.25,
      size.width * 0.85, size.height * 0.65,
      size.width * 0.5, size.height * 0.95,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
