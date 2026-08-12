import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/event_model.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
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
  static final List<EventModel> _initialEvents = [
    // UPCOMING EVENTS
    const EventModel(
      id: 'event_1',
      title: 'Wedding Meet #1',
      subtitle: 'meet',
      date: '30 June 2025',
      time: '6 PM - 9 PM',
      location: 'Akola, Maharashtra',
      organizer: 'Anil Khavilkar',
      description:
          'An exclusive gathering for wedding-ready profiles from across Vidarbha and Marathwada. Enjoy curated speed-networking sessions, family introductions, and high-tea refreshments.',
      status: 'upcoming',
      badgeText: 'SOON',
      images: [
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
      ],
      whatsappNumber: '919856543232',
    ),
    const EventModel(
      id: 'event_2',
      title: 'Wedding Meet #2',
      subtitle: 'meet',
      date: '07 June 2025',
      time: '5 PM - 8 PM',
      location: 'Nagpur, Maharashtra',
      organizer: 'Sunita Nair',
      description:
          'A curated matchmaking event for Marwari and Rajasthani families seeking prospective brides and grooms. Interactive icebreaker activities and direct family interactions.',
      status: 'upcoming',
      badgeText: 'SOON',
      images: [
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
        'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=500',
      ],
      whatsappNumber: '919856543232',
    ),

    // PAST EVENTS
    const EventModel(
      id: 'event_4',
      title: 'Wedding Meet #4',
      subtitle: 'meet',
      date: '23 Apr 2025',
      time: '9 PM',
      location: 'Akola, Maharashtra',
      organizer: 'Anil Khavilkar',
      description:
          'A match made with tradition and love\n\nThe wedding of Priya & Rahul was nothing short of a fairytale, a vibrant celebration where modern love met timeless traditions. Held at the Taj Krishna in Hyderabad on a golden December evening, the festivities began with a Sangeet night where both families danced to Bollywood hits and Telugu folk songs, breaking the ice with laughter and playful competitions. The Mehndi ceremony the next day transformed the courtyard into an aromatic paradise, with intricate henna designs mirroring the couple\'s journey — a delicate fusion of Rahul\'s Punjabi roots and Priya\'s Telugu heritage.\n\nThe wedding morning dawned with a melodic Mangala Vadhyam (traditional percussion) as Priya arrived in a radiant red Kanjeevaram saree, her jewelry echoing temple craftsmanship. Rahul, waiting under the flower-laced mandap, wore a cream sherwani with gold embroidery, his turban tied in the Andhra style as a nod to Priya\'s family. The pelli-kodalu rituals (Telugu wedding customs) unfolded with sacred chants — the Kanyadaan moved guests to tears, while the saat pheres around the agni were lit by a priest blending both Vedic and Punjabi traditions.\n\nAs the couple exchanged vows, a live Carnatic and Sufi fusion band played their favorite melody, symbolizing their cultural harmony. The reception was a grand affair under crystal chandeliers, where guests favored Andhra spices and Amritsari delicacies at food stalls. The highlight? A surprise flash mob by the couple\'s college friends, culminating in Rahul lifting Priya onto his shoulders as fireworks painted the sky.\n\nTheir journey — from meeting at your \'South Meets North\' matrimony mixer to this joyous union — proves that love thrives when hearts align beyond boundaries.',
      status: 'past',
      badgeText: '',
      images: [
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
      ],
      whatsappNumber: '919856543232',
    ),
    const EventModel(
      id: 'event_3',
      title: 'Wedding Meet #3',
      subtitle: 'meet',
      date: '14 Apr 2025',
      time: '4 PM',
      location: 'Nagpur, Maharashtra',
      organizer: 'Matrimony Team',
      description:
          'Beautifully decorated venue in Nagpur. Families from 8 districts attended this grand evening celebrating successful matches at our April matrimonial meet.',
      status: 'past',
      badgeText: '',
      images: [
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=500',
        'https://images.unsplash.com/photo-1583939003579-730e3918a45a?w=500',
      ],
      whatsappNumber: '919856543232',
    ),
  ];

  Future<List<EventModel>> getAllEvents() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _initialEvents;
  }

  Future<EventModel?> getEventById(String eventId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _initialEvents.firstWhere((e) => e.id == eventId);
    } catch (_) {
      return _initialEvents.first;
    }
  }
}
