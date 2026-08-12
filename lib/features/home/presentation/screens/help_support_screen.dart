import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/faq_controller.dart';
import '../widgets/faq_card.dart';
import '../widgets/faq_shimmer_widget.dart';
import '../widgets/ios_search_bar.dart';

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(faqControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9), // Off-white cream background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Back Button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF1E1E1E),
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Help and support',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 4),

              // Subtitle
              Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),

              // Premium iOS Search Bar Component
              IosSearchBar(
                hintText: 'Search',
                onChanged: (query) {
                  ref.read(faqControllerProvider.notifier).search(query);
                },
              ),
              const SizedBox(height: 24),

              // Body Content (Shimmer / Error / Empty / List)
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.isShimmer) {
                      return const SingleChildScrollView(
                        child: FaqShimmerWidget(),
                      );
                    }

                    if (state.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Color(0xFFC2003B),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.error!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 140,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(faqControllerProvider.notifier)
                                      .retry();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC2003B),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Retry',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state.faqs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Try searching for another keyword',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 140,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  ref
                                      .read(faqControllerProvider.notifier)
                                      .loadFAQs(forceRefresh: true);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC2003B),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // FAQ Cards List with Fade-in Animation
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 350),
                      opacity: 1.0,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.faqs.length,
                        itemBuilder: (context, index) {
                          final faq = state.faqs[index];
                          return FaqCard(faq: faq);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
