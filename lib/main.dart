import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crowdin_sdk/crowdin_sdk.dart';
import 'firebase_options.dart';
import 'core/config/crowdin_config.dart';
import 'core/localization/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'l10n/crowdin_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local persistence
  SharedPreferences? prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    debugPrint("Failed to initialize SharedPreferences: $e");
  }

  // Determine initial startup locale
  final savedLanguageCode = prefs?.getString('app_language_code') ?? 'en';
  final initialLocale = savedLanguageCode == 'mr'
      ? SupportedLocales.marathi
      : SupportedLocales.english;

  // Initialize Crowdin SDK for Over-The-Air translation updates
  try {
    await Crowdin.init(
      distributionHash: CrowdinConfig.distributionHash,
      connectionType: InternetConnectionType.any,
      updatesInterval: const Duration(minutes: 25),
    );
    if (CrowdinConfig.isConfigured) {
      await Crowdin.loadTranslations(initialLocale)
          .timeout(const Duration(seconds: 3));
    }
  } catch (e) {
    debugPrint("[Crowdin] Initialization warning: $e");
  }

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase initialized successfully.");
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  runApp(
    ProviderScope(
      overrides: [
        if (prefs != null) sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Soyarik',
      theme: AppTheme.themeData,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: CrowdinLocalization.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
