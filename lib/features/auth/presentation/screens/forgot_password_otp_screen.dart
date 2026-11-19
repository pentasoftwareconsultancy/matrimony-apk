import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/password_controller.dart';
import '../widgets/four_digit_otp_widget.dart';
import '../../../../l10n/app_localizations.dart';

class ForgotPasswordOtpScreen extends ConsumerStatefulWidget {
  const ForgotPasswordOtpScreen({super.key});

  @override
  ConsumerState<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends ConsumerState<ForgotPasswordOtpScreen> {
  String _enteredOtp = '';

  void _onNext() async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(passwordControllerProvider.notifier);
    final success = await controller.verifyOtp(_enteredOtp);
    if (mounted) {
      if (success) {
        context.push('/forgot-password/create-password');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n?.invalidOtpMessage ?? 'Invalid OTP code. Please enter 1234.'),
            backgroundColor: const Color(0xFFC2003B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _onResendCode() async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(passwordControllerProvider.notifier);
    final success = await controller.resendOtp();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.otpSentSuccessfully ?? 'OTP Sent Successfully'),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              Text(
                l10n?.forgotYourPassword ?? 'Forgot your password',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle with Recipient in Bold
              RichText(
                text: TextSpan(
                  text: l10n?.verificationCodeSentTo ?? 'A verification code has been sent to ',
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
              Text(
                l10n?.enterCode ?? 'Enter code',
                style: const TextStyle(
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
                    text: l10n?.resendCodeIn ?? 'You can resend the code in ',
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade500,
                    ),
                    children: [
                      TextSpan(
                        text: '${state.timerSeconds} ${l10n?.seconds ?? 'seconds'}',
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
                      : Text(
                          l10n?.next ?? 'Next',
                          style: const TextStyle(
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
                      l10n?.didntReceiveCode ?? "Didn't receive the code? ",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: state.canResend ? _onResendCode : null,
                      child: Text(
                        l10n?.resendCode ?? 'Resend code',
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
