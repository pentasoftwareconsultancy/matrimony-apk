import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/controllers/password_controller.dart';
import '../../../auth/presentation/widgets/password_checklist_widget.dart';
import '../../../auth/presentation/widgets/password_strength_meter.dart';
import '../../../auth/presentation/widgets/password_success_dialog.dart';
import '../../../auth/presentation/widgets/password_text_field.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onApplyChanges() async {
    final controller = ref.read(passwordControllerProvider.notifier);
    final success = await controller.changePassword();
    if (success && mounted) {
      PasswordSuccessDialog.show(
        context,
        onLoginPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(passwordControllerProvider);

    final isButtonEnabled = state.currentPassword.isNotEmpty &&
        state.isNewPasswordValid &&
        state.doPasswordsMatch;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9), // Off-white cream background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Back Button
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
                'Change password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                'Change the password',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 28),

              // Current Password Field
              PasswordTextField(
                label: 'Current password',
                hintText: 'Enter current password',
                controller: _currentPasswordController,
                isPassword: true,
                errorText: state.currentPasswordError,
                onChanged: (val) {
                  ref.read(passwordControllerProvider.notifier).setCurrentPassword(val);
                },
              ),
              const SizedBox(height: 20),

              // Create New Password Field
              PasswordTextField(
                label: 'Create new password',
                hintText: 'Enter password',
                controller: _newPasswordController,
                isPassword: true,
                onChanged: (val) {
                  ref.read(passwordControllerProvider.notifier).setNewPassword(val);
                },
              ),
              const SizedBox(height: 20),

              // Confirm New Password Field
              PasswordTextField(
                label: 'Confirm new password',
                hintText: 'Enter password',
                controller: _confirmPasswordController,
                isPassword: true,
                onChanged: (val) {
                  ref.read(passwordControllerProvider.notifier).setConfirmPassword(val);
                },
              ),
              const SizedBox(height: 20),

              // Password Strength Meter
              PasswordStrengthMeter(
                score: state.strengthScore,
              ),
              const SizedBox(height: 20),

              // Live Rules Checklist
              PasswordChecklistWidget(
                hasUppercase: state.hasUppercase,
                hasLowercase: state.hasLowercase,
                hasMinLength: state.hasMinLength,
              ),
              const SizedBox(height: 36),

              // Apply Changes Crimson Capsule Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: (isButtonEnabled && !state.isLoading)
                      ? _onApplyChanges
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
                          'Apply Changes',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 28),

              // Footer Link: Forgot password? Click here
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    context.push('/forgot-password');
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Forgot password? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF1E1E1E),
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: 'Click here',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                        ],
                      ),
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
