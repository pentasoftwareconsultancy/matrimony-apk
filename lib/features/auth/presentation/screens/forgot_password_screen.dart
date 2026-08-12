import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/password_controller.dart';
import '../widgets/password_segment_switch.dart';
import '../widgets/password_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(passwordControllerProvider);
      _phoneController.text = state.phone;
      _emailController.text = state.email;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSendCode() async {
    final controller = ref.read(passwordControllerProvider.notifier);
    final success = await controller.sendForgotPasswordOtp();
    if (success && mounted) {
      context.push('/forgot-password/otp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(passwordControllerProvider);
    final isPhoneTab = state.selectedTabIndex == 0;

    final isButtonEnabled = isPhoneTab ? state.isPhoneValid : state.isEmailValid;

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

              // Subtitle
              Text(
                'Please enter email or phone number',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 28),

              // Segment Switch (Phone / Email)
              PasswordSegmentSwitch(
                selectedIndex: state.selectedTabIndex,
                onTabChanged: (index) {
                  ref.read(passwordControllerProvider.notifier).setTabIndex(index);
                },
              ),
              const SizedBox(height: 36),

              // TAB CONTENT (Phone or Email Input)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: isPhoneTab
                    ? PasswordTextField(
                        key: const ValueKey('phone_input'),
                        label: 'Phone number',
                        hintText: 'Enter phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        errorText: state.phoneError,
                        onChanged: (val) {
                          ref.read(passwordControllerProvider.notifier).setPhone(val);
                        },
                      )
                    : PasswordTextField(
                        key: const ValueKey('email_input'),
                        label: 'Email',
                        hintText: 'Enter email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        errorText: state.emailError,
                        onChanged: (val) {
                          ref.read(passwordControllerProvider.notifier).setEmail(val);
                        },
                      ),
              ),
              const SizedBox(height: 36),

              // Send Code Crimson Capsule Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (isButtonEnabled && !state.isLoading)
                      ? _onSendCode
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
                          'Send code',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
