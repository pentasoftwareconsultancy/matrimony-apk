import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/faq_model.dart';
import '../services/faq_service.dart';

abstract class FAQRepository {
  Future<List<FAQModel>> getFAQs({bool forceRefresh = false});
  Future<List<FAQModel>> searchFAQ(String keyword);
}

class FAQRepositoryImpl implements FAQRepository {
  final FAQService _service;
  static const String _cacheKey = 'cached_faqs';

  FAQRepositoryImpl(this._service);

  @override
  Future<List<FAQModel>> getFAQs({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Check local cache first unless forceRefresh is true
    if (!forceRefresh) {
      final cachedJsonStr = prefs.getString(_cacheKey);
      if (cachedJsonStr != null && cachedJsonStr.isNotEmpty) {
        try {
          final List<dynamic> jsonList = jsonDecode(cachedJsonStr);
          final cachedList = jsonList.map((e) => FAQModel.fromJson(e)).toList();
          
          // Silently trigger background update
          _refreshAndCache(prefs);

          if (cachedList.isNotEmpty) {
            return cachedList;
          }
        } catch (_) {
          // Fall through on cache parse error
        }
      }
    }

    // 2. Fetch fresh FAQs
    return await _refreshAndCache(prefs);
  }

  Future<List<FAQModel>> _refreshAndCache(SharedPreferences prefs) async {
    final freshList = await _service.fetchFAQsFromApi();
    final jsonList = freshList.map((item) => item.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(jsonList));
    return freshList;
  }

  @override
  Future<List<FAQModel>> searchFAQ(String keyword) async {
    final allFaqs = await getFAQs();
    if (keyword.trim().isEmpty) return allFaqs;

    final lower = keyword.trim().toLowerCase();
    return allFaqs.where((faq) {
      return faq.question.toLowerCase().contains(lower) ||
          faq.answer.toLowerCase().contains(lower);
    }).toList();
  }
}

final faqServiceProvider = Provider<FAQService>((ref) {
  return FAQService();
});

final faqRepositoryProvider = Provider<FAQRepository>((ref) {
  final service = ref.watch(faqServiceProvider);
  return FAQRepositoryImpl(service);
});
