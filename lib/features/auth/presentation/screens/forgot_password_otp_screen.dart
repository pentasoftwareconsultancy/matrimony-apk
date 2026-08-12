import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/password_controller.dart';
import '../widgets/four_digit_otp_widget.dart';

class ForgotPasswordOtpScreen extends ConsumerStatefulWidget {
  const ForgotPasswordOtpScreen({super.key});

  @override
  ConsumerState<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends ConsumerState<ForgotPasswordOtpScreen> {
  String _enteredOtp = '';

  void _onNext() async {
    final controller = ref.read(passwordControllerProvider.notifier);
    final success = await controller.verifyOtp(_enteredOtp);
    if (mounted) {
      if (success) {
        context.push('/forgot-password/create-password');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP code. Please enter 1234.'),
            backgroundColor: Color(0xFFC2003B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _onResendCode() async {
    final controller = ref.read(passwordControllerProvider.notifier);
    final success = await controller.resendOtp();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP Sent Successfully'),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(passwordControllerProvider);
    final recipient = state.activeRecipient;

    final isOtpComplete = _enteredOtp.length == 4;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9), // Off-white cream background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Back Button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.pop(),
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
                'Forgot your password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle with Recipient in Bold
              RichText(
                text: TextSpan(
                  text: 'A verification code has been sent to ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: recipient.isNotEmpty ? recipient : '1234567890',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Label: Enter code
              const Text(
                'Enter code',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 12),

              // 4 OTP Boxes
              FourDigitOtpWidget(
                onChanged: (val) {
                  setState(() {
                    _enteredOtp = val;
                  });
                  ref.read(passwordControllerProvider.notifier).setOtp(val);
                },
                onCompleted: (val) {
                  setState(() {
                    _enteredOtp = val;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Countdown Timer Text
              Center(
                child: RichText(
                  text: TextSpan(
                    text: 'You can resend the code in ',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade500,
                    ),
                    children: [
                      TextSpan(
                        text: '${state.timerSeconds} seconds',
                        style: const TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFC2003B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Next Crimson Capsule Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (isOtpComplete && !state.isLoading)
                      ? _onNext
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC2003B),
                    disabledBackgroundColor: const Color(0xFFC2003B).withValues(alpha: 0.4),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Resend Code Link (Active after timer ends)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code? ",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: state.canResend ? _onResendCode : null,
                      child: Text(
                        'Resend code',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: state.canResend
                              ? const Color(0xFFC2003B)
                              : Colors.grey.shade400,
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
