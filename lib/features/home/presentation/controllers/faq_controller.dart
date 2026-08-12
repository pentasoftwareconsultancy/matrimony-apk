import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/faq_repository.dart';
import '../../domain/models/faq_model.dart';

class FAQState {
  final bool isLoading;
  final bool isShimmer;
  final String? error;
  final List<FAQModel> faqs;

  FAQState({
    this.isLoading = false,
    this.isShimmer = true,
    this.error,
    this.faqs = const [],
  });

  FAQState copyWith({
    bool? isLoading,
    bool? isShimmer,
    String? error,
    List<FAQModel>? faqs,
  }) {
    return FAQState(
      isLoading: isLoading ?? this.isLoading,
      isShimmer: isShimmer ?? this.isShimmer,
      error: error,
      faqs: faqs ?? this.faqs,
    );
  }
}

class FAQController extends StateNotifier<FAQState> {
  final FAQRepository _repository;

  FAQController(this._repository) : super(FAQState()) {
    loadFAQs();
  }

  Future<void> loadFAQs({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, isShimmer: state.faqs.isEmpty, error: null);
    try {
      final faqs = await _repository.getFAQs(forceRefresh: forceRefresh);
      state = state.copyWith(
        isLoading: false,
        isShimmer: false,
        faqs: faqs,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isShimmer: false,
        error: 'Something went wrong',
      );
    }
  }

  Future<void> retry() async {
    await loadFAQs(forceRefresh: true);
  }

  Future<void> search(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final results = await _repository.searchFAQ(query);
      state = state.copyWith(
        isLoading: false,
        faqs: results,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong',
      );
    }
  }
}

final faqControllerProvider =
    StateNotifierProvider<FAQController, FAQState>((ref) {
  final repository = ref.watch(faqRepositoryProvider);
  return FAQController(repository);
});
