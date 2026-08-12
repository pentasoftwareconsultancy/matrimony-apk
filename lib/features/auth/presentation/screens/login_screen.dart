import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../controllers/auth_controller.dart';
import '../controllers/registration_controller.dart';
import '../../../home/presentation/screens/terms_screen.dart';
import '../../../home/presentation/screens/privacy_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final authState = ref.read(authControllerProvider);
        final prefill = authState.tempEmail ?? authState.tempPhone;
        if (prefill != null && prefill.isNotEmpty) {
          _identifierController.text = prefill;
        }
      }
    });
  }

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final input = _identifierController.text.trim();
      final isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);
      
      ref.read(authControllerProvider.notifier).clearError();

      final success = await ref.read(authControllerProvider.notifier).getOTP(
            email: isEmail ? input : null,
            phoneNumber: !isEmail ? input : null,
          );
          
      if (mounted) {
        final authState = ref.read(authControllerProvider);
        if (authState.isNewUser) {
          ref.read(registrationControllerProvider.notifier).updateStep1(
            email: isEmail ? input : null,
            phone: !isEmail ? input : null,
          );
          ref.read(authControllerProvider.notifier).resetNewUserFlag();
          context.push('/register/step1');
        } else if (success) {
          context.push('/otp');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

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
          SystemNavigator.pop();
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
                        flex: 3,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Stylized white logo container
                              Container(
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
                            ],
                          ),
                        ),
                      ),

                      // Bottom container sliding up (white curved container)
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Log In',
                                style: AppTextStyles.titleLarge.copyWith(
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),
                              AppSpacing.verticalLg,

                              // Label Text
                              Text(
                                'Email ID/ Phone number',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              AppSpacing.verticalSm,

                              // Input Field
                              TextFormField(
                                controller: _identifierController,
                                inputFormatters: [
                                  EmailOrPhoneFormatter(),
                                ],
                                decoration: const InputDecoration(
                                  hintText: 'Enter email / phone number',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email or phone number';
                                  }
                                  final input = value.trim();
                                  final isDigitsOnly = RegExp(r'^\d+$').hasMatch(input);
                                  if (isDigitsOnly) {
                                    if (input.length != 10) {
                                      return 'Mobile number must be exactly 10 digits';
                                    }
                                  } else {
                                    final isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+com$', caseSensitive: false).hasMatch(input);
                                    if (!isEmail) {
                                      return 'Please enter a valid email ending with .com';
                                    }
                                  }
                                  return null;
                                },
                              ),
                              AppSpacing.verticalLg,

                              // Get OTP Button
                              ElevatedButton(
                                onPressed: authState.isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12), // Match shape in design
                                  ),
                                ),
                                child: authState.isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Text('Get OTP'),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => context.push('/forgot-password'),
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              AppSpacing.verticalMd,

                              // "Or" separator
                              const Center(
                                child: Text(
                                  'or',
                                  style: TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ),
                              AppSpacing.verticalMd,

                              // Google Log in Button
                              OutlinedButton(
                                onPressed: () {
                                  // Google login placeholder
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Google Sign-In coming soon!')),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 54),
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Log in with '),
                                    Text(
                                      'G',
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppSpacing.verticalLg,

                              // T&C disclaimer text
                              Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: AppTextStyles.caption.copyWith(color: Colors.grey),
                                    children: [
                                      const TextSpan(text: 'By proceeding, you agree to terms\n'),
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const TermsScreen()),
                                            );
                                          },
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Privacy Policy.',
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                                            );
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AppSpacing.verticalLg,

                              // Footer Register Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account? "),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      context.push('/register/step1');
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        'Register',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

class EmailOrPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (RegExp(r'^\d+$').hasMatch(text)) {
      if (text.length > 10) {
        final truncated = text.substring(0, 10);
        return TextEditingValue(
          text: truncated,
          selection: TextSelection.collapsed(offset: 10),
        );
      }
    }
    return newValue;
  }
}
