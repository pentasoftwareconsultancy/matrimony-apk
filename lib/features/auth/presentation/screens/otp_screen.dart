import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/otp_input_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../controllers/auth_controller.dart';
import '../../../../l10n/app_localizations.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  
  Timer? _timer;
  int _secondsRemaining = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pinFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _resendOTP() async {
    final l10n = AppLocalizations.of(context);
    if (_canResend) {
      final authState = ref.read(authControllerProvider);
      ref.read(authControllerProvider.notifier).clearError();
      
      final success = await ref.read(authControllerProvider.notifier).getOTP(
            email: authState.tempEmail,
            phoneNumber: authState.tempPhone,
          );
          
      if (success) {
        _startTimer();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n?.otpResentSuccessfully ?? 'OTP code has been resent!')),
          );
        }
      }
    }
  }

  void _submit() async {
    final l10n = AppLocalizations.of(context);
    final code = _pinController.text;
    if (code.length == 6) {
      ref.read(authControllerProvider.notifier).clearError();
      final success = await ref.read(authControllerProvider.notifier).verifyOTP(code);
      if (success && mounted) {
        context.go('/home');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n?.pleaseEnterAllDigits ?? 'Please enter all 6 digits')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authControllerProvider);
    final identifier = authState.tempEmail ?? authState.tempPhone ?? '';

    ref.listen(authControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
        ref.read(authControllerProvider.notifier).clearError();
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Top header with logo
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 42,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      // Curved white container bottom
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Back Button + Header Row
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.pop(),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  l10n?.otpVerification ?? 'OTP verification',
                                  style: AppTextStyles.titleLarge.copyWith(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.verticalMd,

                            // Description
                            Text(
                              '${l10n?.verificationCodeSentTo ?? 'A verification code has been sent to '}\n$identifier',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                            AppSpacing.verticalLg,

                            // Enter OTP Label
                            Text(
                              l10n?.enterOtp ?? 'Enter Otp',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            AppSpacing.verticalSm,

                            // 6 OTP Boxes using reusable widget
                            OtpInputWidget(
                              controller: _pinController,
                              focusNode: _pinFocusNode,
                              onCompleted: _submit,
                            ),
                            AppSpacing.verticalLg,

                            // Resend code countdown
                            Center(
                              child: _canResend
                                  ? TextButton(
                                      onPressed: _resendOTP,
                                      child: Text(
                                        l10n?.resendOtp ?? 'Resend OTP',
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      '${l10n?.resendCodeIn ?? 'You can resend the code in '}$_secondsRemaining ${l10n?.seconds ?? 'seconds'}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                            ),
                            AppSpacing.verticalLg,

                            // Login Button
                            ElevatedButton(
                              onPressed: authState.isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: authState.isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(l10n?.logIn ?? 'Log in'),
                            ),
                            AppSpacing.verticalLg,

                            // Bottom footer link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(l10n?.alreadyHaveAccount ?? 'Already have an account? '),
                                GestureDetector(
                                  onTap: () => context.pop(),
                                  child: Text(
                                    l10n?.logIn ?? 'Log in',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
   );
  }
}
