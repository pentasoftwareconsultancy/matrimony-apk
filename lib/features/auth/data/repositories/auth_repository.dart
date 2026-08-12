import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user.dart';

abstract class AuthRepository {
  Future<void> login({String? email, String? phoneNumber});
  Future<bool> checkUser(String identifier);
  Future<void> sendOTP({String? email, String? phoneNumber});
  Future<Map<String, dynamic>> verifyOTP({String? email, String? phoneNumber, required String code});
  Future<Map<String, dynamic>> registerProfile(Map<String, dynamic> registrationData);
  Future<Map<String, dynamic>> uploadFiles({
    List<int>? aadharBytes,
    String? aadharFileName,
    List<int>? casteBytes,
    String? casteFileName,
    List<Map<String, dynamic>>? photos,
  });
  Future<User> getMe();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();

  @override
  Future<void> login({String? email, String? phoneNumber}) async {
    return;
  }

  @override
  Future<bool> checkUser(String identifier) async {
    final prefs = await SharedPreferences.getInstance();
    final registeredPhone = prefs.getString('registeredPhone') ?? '';
    final registeredEmail = prefs.getString('registeredEmail') ?? '';
    
    final normalized = identifier.trim().toLowerCase();
    final is10Digits = RegExp(r'^\d{10}$').hasMatch(normalized);
    final isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+com$').hasMatch(normalized);

    if (is10Digits || isValidEmail || normalized == '9876543210' || normalized == 'demo@soyarik.com') {
      return true;
    }
    
    return normalized == registeredPhone.trim().toLowerCase() ||
           normalized == registeredEmail.trim().toLowerCase();
  }

  @override
  Future<void> sendOTP({String? email, String? phoneNumber}) async {
    return;
  }

  @override
  Future<Map<String, dynamic>> verifyOTP({
    String? email,
    String? phoneNumber,
    required String code,
  }) async {
    if (code != '123456') {
      throw Exception('Invalid OTP');
    }

    final prefs = await SharedPreferences.getInstance();
    final input = (email ?? phoneNumber ?? '').trim().toLowerCase();
    final isDemo = input == '9876543210' || input == 'demo@soyarik.com';

    String? profileJsonStr = prefs.getString('profile');
    
    if (profileJsonStr == null && isDemo) {
      // Initialize default demo profile
      final Map<String, dynamic> demoMap = {
        '_id': 'dummy_demo_id',
        'email': 'demo@soyarik.com',
        'phone': '9876543210',
        'fullName': 'Aaradhya Sharma',
        'accountType': 'Self',
        'gender': 'Female',
        'dob': DateTime(1997, 3, 14).toIso8601String(),
        'age': 27,
        'religion': 'Hindu',
        'caste': 'Brahmin',
        'maritalStatus': 'Single',
        'bloodGroup': 'B+',
        'address': 'Pune, Maharashtra, India',
        'hobbies': ['Coding', 'Trekking', 'Classical Music'],
        'rashi': 'Mesh',
        'nakshatra': 'Ashwini',
        'manglik': false,
        'qualification': 'B.Tech (Computer Science)',
        'occupation': 'Software Engineer',
        'annualIncome': '₹9,00,000 LPA',
        'country': 'India',
        'state': 'Maharashtra',
        'city': 'Pune',
        'languages': ['English', 'Hindi', 'Marathi'],
        'fatherName': 'Ramesh Sharma',
        'motherName': 'Sunita Sharma',
        'siblings': 1,
        'familyType': 'Nuclear',
        'familyStatus': 'Upper Middle Class',
        'nativePlace': 'Pune',
        'aboutFamily': 'Simple nuclear family',
        'aadharNumber': '123456789012',
        'aadharCardUrl': 'demo_aadhar.pdf',
        'casteCertificateUrl': 'demo_caste.pdf',
        'casteCertificateName': 'demo_caste.pdf',
        'photos': ['https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500'],
        'profileCompleted': true,
        'isVerified': true,
        'isPremium': true,
        'role': 'user',
      };
      await prefs.setString('profile', jsonEncode(demoMap));
      await prefs.setBool('isRegistered', true);
      await prefs.setString('registeredPhone', '9876543210');
      await prefs.setString('registeredEmail', 'demo@soyarik.com');
      profileJsonStr = jsonEncode(demoMap);
    }

    if (profileJsonStr == null) {
      throw Exception('User not registered. Please register first.');
    }

    final Map<String, dynamic> userMap = jsonDecode(profileJsonStr);
    final registeredPhone = userMap['phone'] ?? '';
    final registeredEmail = userMap['email'] ?? '';
    
    // Check match
    if (!isDemo &&
        input != registeredPhone.trim().toLowerCase() &&
        input != registeredEmail.trim().toLowerCase()) {
      throw Exception('User not registered. Please register first.');
    }

    final user = User.fromJson(userMap);

    return {
      'user': user,
      'token': 'mock_token_jwt_123456',
    };
  }

  @override
  Future<Map<String, dynamic>> registerProfile(Map<String, dynamic> registrationData) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isRegistered', true);
    await prefs.setString('registeredPhone', registrationData['phone'] ?? '');
    await prefs.setString('registeredEmail', registrationData['email'] ?? '');
    await prefs.setString('registeredPassword', registrationData['password'] ?? '');

    final Map<String, dynamic> userMap = {
      '_id': 'dummy_user_id',
      ...registrationData,
      'profileCompleted': true,
      'isVerified': true,
      'isPremium': true,
      'role': 'user',
    };

    userMap.remove('aadharBytes');
    userMap.remove('pickedPhotosData');
    userMap.remove('password');
    userMap.remove('confirmPassword');

    await prefs.setString('profile', jsonEncode(userMap));

    final List<dynamic> photos = registrationData['photos'] ?? [];
    await prefs.setStringList('photos', photos.map((p) => p.toString()).toList());
    await prefs.setString('aadhaar', registrationData['aadharNumber'] ?? '');
    await prefs.setString('aadharCardName', registrationData['aadharCardName'] ?? '');
    await prefs.setString('casteCertificateUrl', registrationData['casteCertificateUrl'] ?? '');
    await prefs.setString('casteCertificateName', registrationData['casteCertificateName'] ?? '');

    final user = User.fromJson(userMap);

    return {
      'user': user,
      'token': 'mock_token_jwt_123456',
    };
  }

  @override
  Future<Map<String, dynamic>> uploadFiles({
    List<int>? aadharBytes,
    String? aadharFileName,
    List<int>? casteBytes,
    String? casteFileName,
    List<Map<String, dynamic>>? photos,
  }) async {
    final photoUrls = <String>[];
    if (photos != null) {
      for (final photo in photos) {
        photoUrls.add(photo['fileName'] as String);
      }
    }
    return {
      'aadharUrl': aadharFileName ?? 'mock_aadhar_url_path.pdf',
      'casteCertificateUrl': casteFileName ?? 'mock_caste_url_path.pdf',
      'photoUrls': photoUrls,
    };
  }

  @override
  Future<User> getMe() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJsonStr = prefs.getString('profile');
    if (profileJsonStr == null) {
      throw Exception('Not authenticated');
    }
    return User.fromJson(jsonDecode(profileJsonStr));
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});
