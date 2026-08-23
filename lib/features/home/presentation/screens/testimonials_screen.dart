import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';

class TestimonialItem {
  final String id;
  final String coupleNames;
  final String weddingDate;
  final String image;
  final String story;
  final double rating;

  const TestimonialItem({
    required this.id,
    required this.coupleNames,
    required this.weddingDate,
    required this.image,
    required this.story,
    required this.rating,
  });

  factory TestimonialItem.fromJson(Map<String, dynamic> json) {
    return TestimonialItem(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      coupleNames: (json['coupleNames'] ?? '').toString(),
      weddingDate: (json['weddingDate'] ?? '').toString(),
      image: (json['image'] ?? 'https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?w=300').toString(),
      story: (json['story'] ?? '').toString(),
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 5.0,
    );
  }
}

final testimonialsProvider = FutureProvider<List<TestimonialItem>>((ref) async {
  try {
    final apiClient = ref.watch(apiClientProvider);
    final response = await apiClient.get('/testimonials');
    final list = response.data['data'] as List<dynamic>;
    return list.map((e) => TestimonialItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  } catch (_) {
    return [];
  }
});

class TestimonialsScreen extends ConsumerWidget {
  const TestimonialsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testimonialsAsync = ref.watch(testimonialsProvider);
    final testimonials = testimonialsAsync.asData?.value ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Success Testimonials',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Real stories from couples who found love on Soyrik',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: testimonials.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text(
                          'No Testimonials Yet',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Success stories will appear here when added.',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: testimonials.length,
                    itemBuilder: (context, index) {
                      final item = testimonials[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(item.image),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.coupleNames,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Married on: ${item.weddingDate}',
                                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF7E6),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.orange, size: 12),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${item.rating}',
                                        style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '"${item.story}"',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
