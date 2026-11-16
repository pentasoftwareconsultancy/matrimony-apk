import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matrimony_app/features/events/data/repositories/event_repository.dart';
import 'package:matrimony_app/features/events/domain/models/event_model.dart';
import 'package:matrimony_app/features/events/presentation/screens/events_screen.dart';

void main() {
  group('EventModel date parsing and upcoming filter', () {
    final nowNov12 = DateTime(2026, 11, 12, 18, 30);

    test('parses website Event schema and standard date formats', () {
      final websiteDoc = EventModel.fromJson({
        '_id': 'ev1',
        'heading': 'Pune Soyrik Meet',
        'subHeading': 'Singles Gathering',
        'img': 'https://example.com/thumb.jpg',
        'imageScroll': ['https://example.com/gallery1.jpg'],
        'date': '2026-11-25',
        'description': 'Meet compatible matches in Pune.',
        'eventInfo': [
          {
            'Date': '25 Nov 2026',
            'Time': '5:00 PM',
            'Location': 'Pune, Maharashtra',
            'Organizers': 'Soyrik Team',
          }
        ],
      });

      expect(websiteDoc.title, 'Pune Soyrik Meet');
      expect(websiteDoc.subtitle, 'Singles Gathering');
      expect(websiteDoc.location, 'Pune, Maharashtra');
      expect(websiteDoc.organizer, 'Soyrik Team');
      expect(websiteDoc.images, [
        'https://example.com/thumb.jpg',
        'https://example.com/gallery1.jpg',
      ]);
      expect(websiteDoc.displayDay, '25');
      expect(websiteDoc.displayMonthYear, 'Nov 2026');
      expect(websiteDoc.formattedDate, '25 Nov 2026');
      expect(websiteDoc.isUpcomingAt(nowNov12), isTrue);
    });

    test('includes today and future events and excludes past events', () {
      final pastEvent = EventModel.fromJson({
        '_id': 'past1',
        'title': 'Old Meet',
        'date': '30 June 2025',
      });
      final yesterdayEvent = EventModel.fromJson({
        '_id': 'past2',
        'title': 'Yesterday Meet',
        'date': '11/11/2026',
      });
      final todayEvent = EventModel.fromJson({
        '_id': 'today1',
        'title': 'Today Meet',
        'date': '12 November 2026',
      });
      final futureEvent = EventModel.fromJson({
        '_id': 'future1',
        'title': 'Future Meet',
        'date': '25-12-2026',
      });

      expect(pastEvent.isUpcomingAt(nowNov12), isFalse);
      expect(yesterdayEvent.isUpcomingAt(nowNov12), isFalse);
      expect(todayEvent.isUpcomingAt(nowNov12), isTrue);
      expect(futureEvent.isUpcomingAt(nowNov12), isTrue);
    });

    test('supports ongoing multi-day events and rejects cancelled/deleted/inactive events', () {
      final ongoing = EventModel.fromJson({
        '_id': 'ongoing1',
        'title': '3-Day Convention',
        'startDate': '2026-11-10',
        'endDate': '2026-11-14',
        'date': '2026-11-10',
      });
      final cancelled = EventModel.fromJson({
        '_id': 'cancel1',
        'title': 'Cancelled Meet',
        'date': '2027-01-15',
        'status': 'cancelled',
      });
      final deleted = EventModel.fromJson({
        '_id': 'del1',
        'title': 'Deleted Meet',
        'date': '2027-01-15',
        'isDeleted': true,
      });
      final inactive = EventModel.fromJson({
        '_id': 'inact1',
        'title': 'Inactive Meet',
        'date': '2027-01-15',
        'isActive': false,
      });

      expect(ongoing.isUpcomingAt(nowNov12), isTrue);
      expect(cancelled.isUpcomingAt(nowNov12), isFalse);
      expect(deleted.isUpcomingAt(nowNov12), isFalse);
      expect(inactive.isUpcomingAt(nowNov12), isFalse);
    });
  });

  group('EventsScreen widget tests', () {
    testWidgets('displays only upcoming events and excludes past/cancelled/deleted events',
        (tester) async {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 5);
      final today = DateTime(now.year, now.month, now.day);
      String isoDay(DateTime dt) =>
          '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

      final mockEvents = [
        const EventModel(
          id: '1',
          title: 'Past Match Meet',
          date: '30 June 2024',
          location: 'Pune',
          description: 'Past event should be excluded.',
          status: 'upcoming',
          images: [],
        ),
        EventModel(
          id: '2',
          title: 'Cancelled Future Meet',
          date: isoDay(tomorrow),
          location: 'Mumbai',
          description: 'Cancelled event.',
          status: 'cancelled',
          images: const [],
        ),
        EventModel(
          id: '3',
          title: 'Today Evening Meet',
          date: isoDay(today),
          location: 'Nashik',
          description: 'Happening today.',
          status: 'upcoming',
          images: const [],
        ),
        EventModel(
          id: '4',
          title: 'Next Week Grand Swayamvar',
          date: isoDay(tomorrow),
          location: 'Pune',
          description: 'Upcoming gathering.',
          status: 'upcoming',
          images: const [],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            eventsProvider.overrideWith((ref) async => mockEvents),
          ],
          child: const MaterialApp(home: EventsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('UPCOMING EVENTS'), findsOneWidget);
      expect(find.text('2 events'), findsOneWidget);
      expect(find.text('Today Evening Meet'), findsOneWidget);
      expect(find.text('Next Week Grand Swayamvar'), findsOneWidget);

      expect(find.text('Past Match Meet'), findsNothing);
      expect(find.text('Cancelled Future Meet'), findsNothing);
      expect(find.text('PAST EVENTS'), findsNothing);

      // Verify vertical list layout (one card per row, card 2 below card 1)
      final card1Pos = tester.getTopLeft(find.text('Today Evening Meet'));
      final card2Pos = tester.getTopLeft(find.text('Next Week Grand Swayamvar'));
      expect(card2Pos.dy, greaterThan(card1Pos.dy));
      expect(card1Pos.dx, equals(card2Pos.dx));
    });

    testWidgets('shows empty state when only past or no upcoming events exist',
        (tester) async {
      final onlyPast = [
        const EventModel(
          id: 'old',
          title: 'Archived 2024 Event',
          date: '15 August 2024',
          location: 'Pune',
          description: 'Old.',
          status: 'past',
          images: [],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            eventsProvider.overrideWith((ref) async => onlyPast),
          ],
          child: const MaterialApp(home: EventsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('0 events'), findsOneWidget);
      expect(find.text('No upcoming events right now'), findsOneWidget);
      expect(find.text('Archived 2024 Event'), findsNothing);
      expect(find.text('PAST EVENTS'), findsNothing);
    });
  });
}
