import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrimony_app/features/profile/domain/models/profile_model.dart';
import 'package:matrimony_app/features/profile/presentation/widgets/profile_summary_card.dart';
import 'package:matrimony_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:matrimony_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:matrimony_app/features/profile/data/repositories/profile_repository.dart';
import 'package:matrimony_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:matrimony_app/features/auth/data/repositories/auth_repository.dart';
import 'package:matrimony_app/features/auth/domain/models/user.dart';
import 'package:matrimony_app/core/storage/secure_storage_service.dart';

void main() {
  group('ProfileScreen and ProfileSummaryCard Avatar & RenderFlex Tests', () {
    testWidgets('ProfileSummaryCard renders empty photos without exception and displays styled avatar placeholder', (WidgetTester tester) async {
      final emptyProfile = ProfileModel.empty().copyWith(
        fullName: 'Sarthak Shelke',
        age: 26,
        photos: [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ProfileSummaryCard(
                profile: emptyProfile,
                onPhotoTap: () {},
                onThumbnailTap: (_) {},
                onEditBioTap: () {},
              ),
            ),
          ),
        ),
      );

      // Verify no exceptions were thrown and the person icon is rendered
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);
      expect(find.text('Sarthak Shelke, age– 26'), findsOneWidget);
    });

    testWidgets('ProfileScreen renders on narrow screen width (320px) without RenderFlex overflow', (WidgetTester tester) async {
      // Simulate narrow 320x640 mobile screen
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final testUser = User.fromJson({
        '_id': 'user123',
        'fullName': 'Sarthak Shelke',
        'role': 'user',
        'isPremium': false,
        'profileCompleted': false,
        'isVerified': true,
        'photos': <String>[],
      });

      final testProfile = ProfileModel.empty().copyWith(
        fullName: 'Sarthak Shelke',
        photos: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith((ref) => _MockAuthController(testUser)),
            profileControllerProvider.overrideWith((ref) => _MockProfileController(testProfile, ref)),
          ],
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pump();

      // Verify no exceptions and elements exist
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Sarthak Shelke'), findsOneWidget);
      expect(find.text('Membership– '), findsOneWidget);
      expect(find.text('free'), findsOneWidget);
      expect(find.byIcon(Icons.person_rounded), findsOneWidget);

      // Check tester does not have any RenderFlex overflow exceptions
      expect(tester.takeException(), isNull);
    });
  });
}

class _MockAuthController extends AuthController {
  final User _mockUser;
  _MockAuthController(this._mockUser) : super(FakeAuthRepository(), FakeSecureStorageService()) {
    state = AuthState(user: _mockUser, isAuthenticated: true);
  }
}

class FakeAuthRepository implements AuthRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeSecureStorageService implements SecureStorageService {
  @override
  Future<String?> getToken() async => 'fake_token';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockProfileController extends ProfileController {
  final ProfileModel _mockProfile;
  _MockProfileController(this._mockProfile, Ref ref) : super(FakeProfileRepository(), ref) {
    state = ProfileState(
      profile: _mockProfile,
      completionPercentage: _mockProfile.calculateCompletionPercentage(),
    );
  }
}

class FakeProfileRepository implements ProfileRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
