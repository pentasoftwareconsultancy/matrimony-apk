import 'package:flutter/material.dart';

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
}

class TestimonialsScreen extends StatelessWidget {
  const TestimonialsScreen({super.key});

  final List<TestimonialItem> _testimonials = const [
    TestimonialItem(
      id: 't_1',
      coupleNames: 'Amit & Rupa Kulkarni',
      weddingDate: 'February 12, 2026',
      image: 'https://images.unsplash.com/photo-1607190074257-dd4b7af0309f?w=300',
      story: 'We met on Soyrik Matrimony last year. The search filters matched our horoscope, city, and family expectations perfectly. We found compatible values instantly. Thank you, Soyrik, for this beautiful connection!',
      rating: 5.0,
    ),
    TestimonialItem(
      id: 't_2',
      coupleNames: 'Sanjay & Meera Deshmukh',
      weddingDate: 'April 29, 2026',
      image: 'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=300',
      story: 'My parents were very particular about matching caste and native place. Soyrik enabled us to locate exactly what we needed within 3 months! The chat detail interface was very clean to coordinate our meetups.',
      rating: 4.8,
    ),
    TestimonialItem(
      id: 't_3',
      coupleNames: 'Vikram & Anjali Joshi',
      weddingDate: 'June 18, 2026',
      image: 'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=300',
      story: 'I upgraded to Gold Premium, and it was the best decision. I could access candidates details, horoscope reviews, and verified profile records instantly. Found my soulmate Anjali within weeks!',
      rating: 5.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _testimonials.length,
              itemBuilder: (context, index) {
                final item = _testimonials[index];

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
