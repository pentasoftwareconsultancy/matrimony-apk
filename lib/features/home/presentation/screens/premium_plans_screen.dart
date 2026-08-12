import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/models/user.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class PremiumPlansScreen extends ConsumerStatefulWidget {
  const PremiumPlansScreen({super.key});

  @override
  ConsumerState<PremiumPlansScreen> createState() => _PremiumPlansScreenState();
}

class _PremiumPlansScreenState extends ConsumerState<PremiumPlansScreen> {
  String _selectedPlan = 'Silver';

  final Map<String, List<String>> _planFeatures = {
    'Silver': [
      'Unlimited profile browsing',
      '20 interest requests per month',
      'Chat with accepted matches',
      'Basic search filters',
      'Public photo access',
      'Standard support',
    ],
    'Gold': [
      'Unlimited profile browsing',
      '50 interest requests per month',
      'Chat with accepted matches',
      'Advanced search filters',
      'Public photo access',
      'Priority support',
      'Horoscope matching',
    ],
    'Platinum': [
      'Unlimited profile browsing',
      'Unlimited interest requests',
      'Chat with accepted matches',
      'Premium search & filters',
      'View contact details directly',
      'Horoscope matching',
      'Relationship manager support',
      'Highlight profile in search results',
    ],
  };

  final Map<String, String> _planPrices = {
    'Silver': '₹999/-',
    'Gold': '₹2,499/-',
    'Platinum': '₹4,999/-',
  };

  void _startPaymentFlow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _RazorpaySimulator(
        plan: _selectedPlan,
        price: _planPrices[_selectedPlan]!,
        onSuccess: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('premiumPlan', _selectedPlan);
          await prefs.setBool('isPremium', true);

          // Update user state
          final profileStr = prefs.getString('profile');
          if (profileStr != null) {
            final Map<String, dynamic> userMap = jsonDecode(profileStr);
            userMap['isPremium'] = true;
            userMap['premiumPlan'] = _selectedPlan;
            await prefs.setString('profile', jsonEncode(userMap));
            final updatedUser = User.fromJson(userMap);
            ref.read(authControllerProvider.notifier).setAuthenticatedState(updatedUser);
          }

          if (mounted) {
            Navigator.pop(context); // Close checkout
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSuccessScreen(plan: _selectedPlan),
              ),
            );
          }
        },
        onFailure: () {
          Navigator.pop(context); // Close checkout
          _showFailureDialog();
        },
      ),
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Failed', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        content: const Text('Your transaction could not be completed. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startPaymentFlow();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
          'Go Premium',
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
              'Find more accurate match with premium',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),

          // Plan Cards horizontal slider
          SizedBox(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildPlanCard('Silver', '₹999/-', Icons.star, Colors.red.shade900),
                _buildPlanCard('Gold', '₹2,499/-', Icons.diamond, Colors.amber.shade800),
                _buildPlanCard('Platinum', '₹4,999/-', Icons.workspace_premium, Colors.deepPurple.shade900),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Selected Plan Features List Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _selectedPlan == 'Silver'
                              ? Icons.star
                              : _selectedPlan == 'Gold'
                                  ? Icons.diamond
                                  : Icons.workspace_premium,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedPlan,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: _planFeatures[_selectedPlan]!
                            .map((f) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          f,
                                          style: const TextStyle(fontSize: 13, color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Continue Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: _startPaymentFlow,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(String planName, String price, IconData icon, Color mainColor) {
    final isSelected = _selectedPlan == planName;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = planName),
      child: Container(
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: isSelected ? Colors.white : mainColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  planName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'per month',
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.grey,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RazorpaySimulator extends StatefulWidget {
  final String plan;
  final String price;
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  const _RazorpaySimulator({
    required this.plan,
    required this.price,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  State<_RazorpaySimulator> createState() => _RazorpaySimulatorState();
}

class _RazorpaySimulatorState extends State<_RazorpaySimulator> {
  String _status = 'Initializing Payment...';
  bool _showActions = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _status = 'Razorpay Secure Checkout';
          _showActions = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.payment, color: Colors.blue, size: 24),
                const SizedBox(width: 8),
                Text(
                  _status,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Plan: ${widget.plan}',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Amount: ${widget.price}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
            ),
            const SizedBox(height: 24),
            if (!_showActions)
              const CircularProgressIndicator(color: AppColors.primary)
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: widget.onFailure,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                      foregroundColor: Colors.red.shade700,
                      elevation: 0,
                    ),
                    child: const Text('Simulate Failure'),
                  ),
                  ElevatedButton(
                    onPressed: widget.onSuccess,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade100,
                      foregroundColor: Colors.green.shade700,
                      elevation: 0,
                    ),
                    child: const Text('Simulate Success'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  final String plan;

  const PaymentSuccessScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Payment Successful!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 12),
              Text(
                'Congratulations! You are now subscribed to the $plan plan. Premium badges and benefits have been applied to your account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to profile
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Return to Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
