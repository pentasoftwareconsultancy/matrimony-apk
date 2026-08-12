import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';

import 'package:shared_preferences/shared_preferences.dart';

class OnboardingModel {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingModel({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<OnboardingModel> _pages = [
    OnboardingModel(
      imagePath: 'assets/images/onboarding1.png',
      title: 'Crafting Beautiful\nBeginnings',
      description: 'A thoughtful space designed for intentional connections and shared futures. We move beyond filters to help you find a partner who truly aligns with your life goals.',
    ),
    OnboardingModel(
      imagePath: 'assets/images/onboarding2.png',
      title: 'Two Lives, One Perfect\nAlignment',
      description: 'Where family, compatibility, and shared dreams gracefully bring two families together, let us help you discover the connection you\'ve been waiting for.',
    ),
    OnboardingModel(
      imagePath: 'assets/images/onboarding3.png',
      title: 'The Trusted & Secure\nApproach',
      description: 'Simplifying the search for a life partner with absolute clarity and elegance. Welcome to a sophisticated way of finding your forever.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _navigateToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
    if (mounted) {
      context.go('/login');
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentPage > 0) {
          _pageController.animateToPage(
            _currentPage - 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(

          children: [
            // Top logo header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Image.asset(
                'assets/images/logo.png',
                height: 38,
                fit: BoxFit.contain,
              ),
            ),
            
            // Onboarding pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Heart illustration
                        SizedBox(
                          height: size.height * 0.35,
                          child: index == 0
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/heart.png',
                                      fit: BoxFit.contain,
                                    ),
                                    Positioned(
                                      bottom: 24, // Shift couple slightly down to match design overlapping the bottom curve of the heart
                                      child: Image.asset(
                                        'assets/images/couple1.png',
                                        fit: BoxFit.contain,
                                        height: size.height * 0.26,
                                      ),
                                    ),
                                  ],
                                )
                              : Image.asset(
                                  page.imagePath,
                                  fit: BoxFit.contain,
                                ),
                        ),
                        AppSpacing.verticalXl,
                        
                        // Title
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.displayLarge.copyWith(
                            color: AppColors.textDark,
                          ),
                        ),
                        AppSpacing.verticalMd,
                        
                        // Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip button
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Bottom dot indicators
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? AppColors.primary : AppColors.border,
                        ),
                      );
                    }),
                  ),

                  // Next button (circular pill)
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      minimumSize: const Size(90, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward, size: 16),
                      ],
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
