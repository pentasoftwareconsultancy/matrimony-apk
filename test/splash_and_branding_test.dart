import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrimony_app/features/auth/presentation/screens/splash_screen.dart';

void main() {
  group('Splash Screen & App Launcher Branding Isolation Tests', () {
    test('Dedicated assets exist and original Soyarik logo is preserved', () {
      final splashAsset = File('assets/images/splash_screen.png');
      final appLogoAsset = File('assets/images/app_logo.png');
      final originalSoyarikLogo = File('assets/images/logo.png');

      expect(splashAsset.existsSync(), isTrue, reason: 'assets/images/splash_screen.png must exist');
      expect(appLogoAsset.existsSync(), isTrue, reason: 'assets/images/app_logo.png must exist');
      expect(originalSoyarikLogo.existsSync(), isTrue, reason: 'Original assets/images/logo.png must exist');

      // Ensure original logo was NOT overwritten by the new splash or app logo
      final originalBytes = originalSoyarikLogo.readAsBytesSync();
      final splashBytes = splashAsset.readAsBytesSync();
      final appLogoBytes = appLogoAsset.readAsBytesSync();

      expect(originalBytes.length, isNot(equals(splashBytes.length)));
      expect(originalBytes.length, isNot(equals(appLogoBytes.length)));
    });

    testWidgets('SplashScreen exclusively displays assets/images/splash_screen.png with contain fit',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SplashScreen(),
          ),
        ),
      );

      // Verify the Image.asset widget uses the new dedicated splash_screen.png
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.image, isA<AssetImage>());
      final AssetImage assetImage = imageWidget.image as AssetImage;
      expect(assetImage.assetName, 'assets/images/splash_screen.png');
      expect(imageWidget.fit, BoxFit.contain);
    });

    test('Source code audit: splash_screen.png is only referenced by SplashScreen', () {
      final libDir = Directory('lib');
      final dartFiles = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

      int referencesCount = 0;
      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        if (content.contains('splash_screen.png')) {
          referencesCount++;
          expect(
            file.path.replaceAll('\\', '/'),
            contains('lib/features/auth/presentation/screens/splash_screen.dart'),
            reason: 'Only splash_screen.dart should reference splash_screen.png',
          );
        }
      }

      expect(referencesCount, 1);
    });

    test('Source code audit: Login, Onboarding, OTP retain original assets/images/logo.png', () {
      final loginFile = File('lib/features/auth/presentation/screens/login_screen.dart');
      final onboardingFile = File('lib/features/auth/presentation/screens/onboarding_screen.dart');
      final otpFile = File('lib/features/auth/presentation/screens/otp_screen.dart');

      expect(loginFile.readAsStringSync(), contains('assets/images/logo.png'));
      expect(onboardingFile.readAsStringSync(), contains('assets/images/logo.png'));
      expect(otpFile.readAsStringSync(), contains('assets/images/logo.png'));
    });

    test('Application display name is configured as Soyarik across all platforms', () {
      final androidManifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
      expect(androidManifest, contains('android:label="Soyarik"'));

      final infoPlist = File('ios/Runner/Info.plist').readAsStringSync().replaceAll('\r', '');
      expect(infoPlist, contains('<key>CFBundleDisplayName</key>\n\t<string>Soyarik</string>'));

      final mainDart = File('lib/main.dart').readAsStringSync();
      expect(mainDart, contains("title: 'Soyarik'"));

      final webHtml = File('web/index.html').readAsStringSync();
      expect(webHtml, contains('<title>Soyarik</title>'));

      final webManifest = File('web/manifest.json').readAsStringSync();
      expect(webManifest, contains('"name": "Soyarik"'));

      final windowsMain = File('windows/runner/main.cpp').readAsStringSync();
      expect(windowsMain, contains('L"Soyarik"'));

      final linuxMain = File('linux/runner/my_application.cc').readAsStringSync();
      expect(linuxMain, contains('"Soyarik"'));
    });

    test('Launcher icon configuration has centered adaptive icon and zero inset', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      expect(pubspec, contains('adaptive_icon_foreground: "assets/images/app_logo_foreground.png"'));
      expect(pubspec, contains('adaptive_icon_foreground_inset: 0'));

      final icLauncherXml = File('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml').readAsStringSync();
      expect(icLauncherXml, contains('android:inset="0%"'));

      final foregroundAsset = File('assets/images/app_logo_foreground.png');
      expect(foregroundAsset.existsSync(), isTrue);
    });
  });
}
