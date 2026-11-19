import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/controllers/registration_controller.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/registration_stepper_screen.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../features/home/presentation/screens/home_screen.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_otp_screen.dart';
import '../../features/auth/presentation/screens/create_new_password_screen.dart';
import '../../features/home/presentation/screens/change_password_screen.dart';
import '../../features/home/presentation/screens/help_support_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/services/presentation/screens/services_screen.dart';
import '../../features/services/presentation/screens/vendor_list_screen.dart';
import '../../features/events/presentation/screens/events_screen.dart';

const _registerRouteNames = [
  'register_step1',
  'register_step2',
  'register_step3',
  'register_step4',
  'register_step5',
  'register_review',
];

// Single shell wrapper hosting RegistrationStepperScreen once across all step routes
class StepperNavigationWrapper extends ConsumerWidget {
  const StepperNavigationWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sync currentStep transitions via GoRouter without pushing duplicate stepper screens onto the stack
    ref.listen<int>(
      registrationControllerProvider.select((s) => s.currentStep),
      (prev, next) {
        if (prev != null && next != prev && next >= 0 && next < _registerRouteNames.length) {
          context.goNamed(_registerRouteNames[next]);
        }
      },
    );

    // Whenever we open the registration shell with empty draft data, prefill from authenticated user
    final regState = ref.read(registrationControllerProvider);
    if (regState.fullName.isEmpty && regState.email.isEmpty && regState.phone.isEmpty) {
      final authUser = ref.read(authControllerProvider).user;
      if (authUser != null) {
        Future.microtask(() {
          ref.read(registrationControllerProvider.notifier).updateStep1(
                fullName: authUser.fullName,
                email: authUser.email,
                phone: authUser.phone,
                accountType: authUser.accountType,
                password: regState.password,
                confirmPassword: regState.confirmPassword,
              );
        });
      }
    }

    return const RegistrationStepperScreen();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot_password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/forgot-password/otp',
        name: 'forgot_password_otp',
        builder: (context, state) => const ForgotPasswordOtpScreen(),
      ),
      GoRoute(
        path: '/forgot-password/create-password',
        name: 'create_new_password',
        builder: (context, state) => const CreateNewPasswordScreen(),
      ),
      GoRoute(
        path: '/change-password',
        name: 'change_password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/help-support',
        name: 'help_support',
        builder: (context, state) => const HelpSupportScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => const StepperNavigationWrapper(),
        routes: [
          GoRoute(
            path: '/register/step1',
            name: 'register_step1',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/register/step2',
            name: 'register_step2',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/register/step3',
            name: 'register_step3',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/register/step4',
            name: 'register_step4',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/register/step5',
            name: 'register_step5',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/register/review',
            name: 'register_review',
            builder: (context, state) => const SizedBox.shrink(),
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit_profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/services',
        name: 'services',
        builder: (context, state) => const ServicesScreen(),
      ),
      GoRoute(
        path: '/services/:category',
        name: 'vendor_list',
        builder: (context, state) {
          final category = state.pathParameters['category'] ?? 'photography';
          return VendorListScreen(category: category);
        },
      ),
      GoRoute(
        path: '/events',
        name: 'events',
        builder: (context, state) => const EventsScreen(),
      ),
    ],
    redirect: (context, state) async {
      final secureStorage = ref.read(secureStorageProvider);
      final matched = state.matchedLocation;

      if (matched == '/splash') {
        return null;
      }
      await ref.read(authControllerProvider.notifier).initialization;

      final authState = ref.read(authControllerProvider);

      // Keep the current route if the session could not be verified.
      // Do not treat a temporary backend error as an incomplete profile.
      if (authState.isAuthenticated &&
          authState.user == null &&
          authState.error != null) {
        return null;
      }
      if (authState.isNewUser) {
        Future.microtask(() {
          ref.read(authControllerProvider.notifier).resetNewUserFlag();
        });
        return '/register/step1';
      }

      final prefs = await SharedPreferences.getInstance();
      final seenOnboarding = prefs.getBool('onboardingCompleted') ?? false;
      if (!seenOnboarding) {
        if (matched == '/') {
          return null;
        }
        return '/';
      }

      final token = await secureStorage.getToken();
      if (token == null) {
        if (matched == '/' ||
            matched == '/login' ||
            matched == '/otp' ||
            matched.startsWith('/register') ||
            matched.startsWith('/forgot-password') ||
            matched == '/change-password' ||
            matched == '/help-support') {
          return null;
        }
        return '/login';
      }

      final user = authState.user;
      final profileCompleted = user?.profileCompleted ?? false;

      if (!profileCompleted) {
        if (matched.startsWith('/register')) {
          return null;
        }
        return '/register/step1';
      }

      if (matched == '/home' ||
          matched == '/profile' ||
          matched == '/edit-profile' ||
          matched.startsWith('/services') ||
          matched.startsWith('/events')) {
        return null;
      }
      return '/home';
    },
  );
});
