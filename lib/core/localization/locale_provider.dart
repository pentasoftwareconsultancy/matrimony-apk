import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crowdin_sdk/crowdin_sdk.dart';
import '../config/crowdin_config.dart';
import '../../l10n/app_localizations.dart';

/// Extension for fast, convenient access to localized strings: `context.l10n.<key>`
extension LocalizationContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

const String _languageStorageKey = 'app_language_code';

/// Supported locales in the application.
class SupportedLocales {
  static const Locale english = Locale('en');
  static const Locale marathi = Locale('mr');

  static const List<Locale> all = [english, marathi];

  static bool isSupported(Locale locale) {
    return all.any((l) => l.languageCode == locale.languageCode);
  }
}

/// State notifier managing the currently selected application locale.
class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences? _prefs;

  LocaleNotifier(this._prefs) : super(_determineInitialLocale(_prefs));

  static Locale _determineInitialLocale(SharedPreferences? prefs) {
    if (prefs != null) {
      final savedCode = prefs.getString(_languageStorageKey);
      if (savedCode != null && savedCode.isNotEmpty) {
        if (savedCode == 'mr') return SupportedLocales.marathi;
        return SupportedLocales.english;
      }
    }
    return SupportedLocales.english;
  }

  /// Change application language immediately and persist selection.
  Future<void> setLocale(Locale newLocale) async {
    if (!SupportedLocales.isSupported(newLocale)) return;
    if (state.languageCode == newLocale.languageCode) return;

    // Update state immediately so UI updates in real-time
    state = newLocale;

    // Persist choice
    if (_prefs != null) {
      await _prefs.setString(_languageStorageKey, newLocale.languageCode);
    }

    // Attempt Over-The-Air Crowdin translation fetch safely in background
    if (CrowdinConfig.isConfigured) {
      try {
        await Crowdin.loadTranslations(newLocale)
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        debugPrint('[Crowdin] Failed to load remote translations for $newLocale: $e');
      }
    }
  }

  /// Convenience method to switch language by language code ('en' or 'mr')
  Future<void> setLanguageCode(String code) async {
    final target = code == 'mr' ? SupportedLocales.marathi : SupportedLocales.english;
    await setLocale(target);
  }
}

/// Provider for SharedPreferences instance.
final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) => null);

/// Provider for application locale.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});
