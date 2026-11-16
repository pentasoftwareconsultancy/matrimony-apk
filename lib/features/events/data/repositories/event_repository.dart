import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/models/event_model.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EventRepository(apiClient);
});

final eventsProvider = FutureProvider<List<EventModel>>((ref) async {
  final repo = ref.watch(eventRepositoryProvider);
  return repo.getAllEvents();
});

final eventByIdProvider =
    FutureProvider.family<EventModel?, String>((ref, eventId) async {
  final repo = ref.watch(eventRepositoryProvider);
  return repo.getEventById(eventId);
});

class EventRepository {
  final ApiClient _apiClient;

  EventRepository(this._apiClient);

  Future<List<EventModel>> getAllEvents() async {
    try {
      final response = await _apiClient.get('/events');
      final raw = response.data;
      final list = raw is Map<String, dynamic>
          ? (raw['data'] as List<dynamic>? ?? const [])
          : (raw is List<dynamic> ? raw : const []);
      final upcoming = list
          .whereType<Map<String, dynamic>>()
          .map(EventModel.fromJson)
          .where((event) => event.isUpcoming)
          .toList()
        ..sort((a, b) => a.compareByDate(b));
      return upcoming;
    } catch (_) {
      return [];
    }
  }

  Future<EventModel?> getEventById(String eventId) async {
    try {
      final response = await _apiClient.get('/events/$eventId');
      final data = response.data['data'] as Map<String, dynamic>;
      return EventModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}
