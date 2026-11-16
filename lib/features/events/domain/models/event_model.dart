import 'package:intl/intl.dart';

class EventModel {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String? startDate;
  final String? endDate;
  final String? timezone;
  final String time;
  final String location;
  final String organizer;
  final String description;
  final String status;
  final bool isCancelled;
  final bool isDeleted;
  final bool isActive;
  final String badgeText;
  final List<String> images;
  final String whatsappNumber;

  const EventModel({
    required this.id,
    required this.title,
    this.subtitle = 'meet',
    required this.date,
    this.startDate,
    this.endDate,
    this.timezone,
    this.time = '9 PM',
    required this.location,
    this.organizer = 'Matrimony Team',
    required this.description,
    required this.status,
    this.isCancelled = false,
    this.isDeleted = false,
    this.isActive = true,
    this.badgeText = 'SOON',
    required this.images,
    this.whatsappNumber = '919856543232',
  });

  static const Set<String> _excludedStatuses = {
    'past',
    'cancelled',
    'canceled',
    'deleted',
    'inactive',
    'expired',
    'completed',
    'archived',
    'draft',
    'disabled',
    'hidden',
  };

  static const Map<String, int> _monthMap = {
    'jan': 1, 'january': 1,
    'feb': 2, 'february': 2,
    'mar': 3, 'march': 3,
    'apr': 4, 'april': 4,
    'may': 5,
    'jun': 6, 'june': 6,
    'jul': 7, 'july': 7,
    'aug': 8, 'august': 8,
    'sep': 9, 'sept': 9, 'september': 9,
    'oct': 10, 'october': 10,
    'nov': 11, 'november': 11,
    'dec': 12, 'december': 12,
  };

  static String? _firstNonEmptyString(List<dynamic> candidates) {
    for (final candidate in candidates) {
      if (candidate is String && candidate.trim().isNotEmpty) {
        return candidate.trim();
      }
    }
    return null;
  }

  static Map<String, dynamic>? _extractEventInfo(dynamic rawEventInfo) {
    if (rawEventInfo is List && rawEventInfo.isNotEmpty) {
      final first = rawEventInfo.first;
      if (first is Map<String, dynamic>) return first;
      if (first is Map) return Map<String, dynamic>.from(first);
    } else if (rawEventInfo is Map<String, dynamic>) {
      return rawEventInfo;
    } else if (rawEventInfo is Map) {
      return Map<String, dynamic>.from(rawEventInfo);
    }
    return null;
  }

  static List<String> _extractImages(Map<String, dynamic> json) {
    final direct = (json['images'] as List<dynamic>?)
        ?.map((e) => e.toString().trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (direct != null && direct.isNotEmpty) {
      return direct;
    }

    final merged = <String>[];
    final thumb = json['img']?.toString().trim();
    if (thumb != null && thumb.isNotEmpty && thumb != 'null') {
      merged.add(thumb);
    }
    final scroll = json['imageScroll'];
    if (scroll is List) {
      for (final item in scroll) {
        final url = item?.toString().trim();
        if (url != null && url.isNotEmpty && url != 'null' && !merged.contains(url)) {
          merged.add(url);
        }
      }
    }
    return merged;
  }

  static DateTime? _validatedCalendarDate(int year, int month, int day) {
    if (year < 1900 || year > 2100 || month < 1 || month > 12 || day < 1 || day > 31) {
      return null;
    }
    final dt = DateTime(year, month, day);
    if (dt.year != year || dt.month != month || dt.day != day) {
      return null;
    }
    return dt;
  }

  static DateTime _toTimezoneCalendarDay(DateTime instant, String? timezone) {
    final tz = timezone?.trim().toLowerCase();
    if (tz == 'asia/kolkata' || tz == 'ist') {
      final ist = instant.toUtc().add(const Duration(hours: 5, minutes: 30));
      return DateTime(ist.year, ist.month, ist.day);
    }
    if (tz == 'utc') {
      final utc = instant.toUtc();
      return DateTime(utc.year, utc.month, utc.day);
    }
    final local = instant.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  /// Parses an event date string into a calendar [DateTime] (midnight),
  /// respecting explicit timestamps and date-only calendar strings safely.
  static DateTime? parseEventDate(String? raw, {String? timezone}) {
    if (raw == null) return null;
    final cleaned = raw
        .trim()
        .replaceFirst(
          RegExp(r'^(mon|tue|tues|wed|thu|thur|thurs|fri|sat|sun)[a-z]*,?\s+', caseSensitive: false),
          '',
        );
    if (cleaned.isEmpty) return null;

    // 1. ISO timestamp with explicit time + offset/Z (e.g. "2026-11-12T18:30:00.000Z")
    if (RegExp(r'(T|\d{2}:\d{2})').hasMatch(cleaned) &&
        RegExp(r'(Z|[+-]\d{2}:?\d{2})$', caseSensitive: false).hasMatch(cleaned)) {
      final parsed = DateTime.tryParse(cleaned);
      if (parsed != null) {
        return _toTimezoneCalendarDay(parsed, timezone);
      }
    }

    // 2. Date-only YYYY-MM-DD / YYYY/MM/DD / YYYY.MM.DD
    final ymd = RegExp(r'^(\d{4})[-/.](\d{1,2})[-/.](\d{1,2})(?:[T\s].*)?$').firstMatch(cleaned);
    if (ymd != null) {
      return _validatedCalendarDate(
        int.parse(ymd.group(1)!),
        int.parse(ymd.group(2)!),
        int.parse(ymd.group(3)!),
      );
    }

    // 3. DD/MM/YYYY, DD-MM-YYYY, or DD.MM.YYYY (Indian convention first, fallback MM/DD/YYYY)
    final dmy = RegExp(r'^(\d{1,2})[-/.](\d{1,2})[-/.](\d{4})$').firstMatch(cleaned);
    if (dmy != null) {
      final first = int.parse(dmy.group(1)!);
      final second = int.parse(dmy.group(2)!);
      final year = int.parse(dmy.group(3)!);
      if (second > 12 && first <= 12) {
        return _validatedCalendarDate(year, first, second);
      }
      return _validatedCalendarDate(year, second, first);
    }

    // 4. Natural English: "30 June 2026", "30th June, 2026", "5-Nov-2026"
    final dMonY = RegExp(
      r'^(\d{1,2})(?:st|nd|rd|th)?[\s,-]+([a-zA-Z]+)[\s,.-]+(\d{4})$',
    ).firstMatch(cleaned);
    if (dMonY != null) {
      final month = _monthMap[dMonY.group(2)!.toLowerCase()];
      if (month != null) {
        return _validatedCalendarDate(
          int.parse(dMonY.group(3)!),
          month,
          int.parse(dMonY.group(1)!),
        );
      }
    }

    // 5. Natural English: "June 30, 2026", "Nov 5 2026"
    final monDY = RegExp(
      r'^([a-zA-Z]+)[\s.-]+(\d{1,2})(?:st|nd|rd|th)?[\s,.-]+(\d{4})$',
    ).firstMatch(cleaned);
    if (monDY != null) {
      final month = _monthMap[monDY.group(1)!.toLowerCase()];
      if (month != null) {
        return _validatedCalendarDate(
          int.parse(monDY.group(3)!),
          month,
          int.parse(monDY.group(2)!),
        );
      }
    }

    final fallback = DateTime.tryParse(cleaned);
    if (fallback != null) {
      return _toTimezoneCalendarDay(fallback, timezone);
    }

    return null;
  }

  ({DateTime? start, DateTime? end}) _resolveDateWindow() {
    final rawPrimary = _firstNonEmptyString([startDate, date]);
    DateTime? parsedStart = parseEventDate(rawPrimary, timezone: timezone);
    DateTime? parsedEnd = parseEventDate(endDate, timezone: timezone);

    // Handle inline date range strings like "10-15 Nov 2026" or "10 Nov 2026 - 15 Nov 2026"
    if (parsedEnd == null && rawPrimary != null) {
      final shortRange = RegExp(
        r'^(\d{1,2}(?:st|nd|rd|th)?)\s*[-–—]\s*(\d{1,2}(?:st|nd|rd|th)?[\s,-]+[a-zA-Z]+[\s,.-]+\d{4})$',
      ).firstMatch(rawPrimary);
      if (shortRange != null) {
        final endCandidate = parseEventDate(shortRange.group(2), timezone: timezone);
        final tail = RegExp(r'^\d{1,2}(?:st|nd|rd|th)?([\s,-]+[a-zA-Z]+[\s,.-]+\d{4})$')
            .firstMatch(shortRange.group(2)!);
        final startCandidate = tail != null
            ? parseEventDate('${shortRange.group(1)}${tail.group(1)}', timezone: timezone)
            : endCandidate;
        parsedStart = startCandidate ?? endCandidate;
        parsedEnd = endCandidate;
      } else {
        final sepMatch = RegExp(r'\s+(?:to|-|–|—)\s+', caseSensitive: false).firstMatch(rawPrimary);
        if (sepMatch != null) {
          final left = rawPrimary.substring(0, sepMatch.start);
          final right = rawPrimary.substring(sepMatch.end);
          final startCandidate = parseEventDate(left, timezone: timezone);
          final endCandidate = parseEventDate(right, timezone: timezone);
          if (startCandidate != null || endCandidate != null) {
            parsedStart = startCandidate ?? endCandidate;
            parsedEnd = endCandidate ?? startCandidate;
          }
        }
      }
    }

    return (start: parsedStart, end: parsedEnd);
  }

  DateTime? get parsedStartDate => _resolveDateWindow().start;
  DateTime? get parsedEndDate => _resolveDateWindow().end;

  /// Returns true only when this event is active, not cancelled/deleted, and
  /// its effective date (or end date for multi-day ongoing events) is today or in the future.
  bool isUpcomingAt([DateTime? referenceNow]) {
    if (isCancelled || isDeleted || !isActive) return false;
    if (_excludedStatuses.contains(status.trim().toLowerCase())) return false;

    final window = _resolveDateWindow();
    final effectiveDay = window.end ?? window.start;
    if (effectiveDay == null) return false;

    final now = referenceNow ?? DateTime.now();
    final today = timezone != null ? _toTimezoneCalendarDay(now, timezone) : DateTime(now.year, now.month, now.day);
    return !effectiveDay.isBefore(today);
  }

  bool get isUpcoming => isUpcomingAt();

  int compareByDate(EventModel other) {
    final a = parsedStartDate ?? parsedEndDate;
    final b = other.parsedStartDate ?? other.parsedEndDate;
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }

  String get displayDay {
    final dt = parsedStartDate ?? parsedEndDate;
    if (dt != null) {
      return DateFormat('dd').format(dt);
    }
    final parts = date.trim().split(RegExp(r'\s+'));
    return parts.isNotEmpty ? parts.first : '';
  }

  String get displayMonthYear {
    final dt = parsedStartDate ?? parsedEndDate;
    if (dt != null) {
      return DateFormat('MMM yyyy').format(dt);
    }
    final parts = date.trim().split(RegExp(r'\s+'));
    return parts.length > 1 ? parts.sublist(1).join(' ') : '';
  }

  String get formattedDate {
    final start = parsedStartDate;
    final end = parsedEndDate;
    if (start != null && end != null && start != end) {
      return '${DateFormat('dd MMM').format(start)} - ${DateFormat('dd MMM yyyy').format(end)}';
    }
    final dt = start ?? end;
    if (dt != null) {
      return DateFormat('dd MMM yyyy').format(dt);
    }
    return date;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'date': date,
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (timezone != null) 'timezone': timezone,
        'time': time,
        'location': location,
        'organizer': organizer,
        'description': description,
        'status': status,
        'isCancelled': isCancelled,
        'isDeleted': isDeleted,
        'isActive': isActive,
        'badgeText': badgeText,
        'images': images,
        'whatsappNumber': whatsappNumber,
      };

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final info = _extractEventInfo(json['eventInfo']);
    final resolvedStartDate = _firstNonEmptyString([json['startDate'], json['start_date']]);
    final resolvedEndDate = _firstNonEmptyString([
      json['endDate'],
      json['end_date'],
      info?['EndDate'],
      info?['endDate'],
    ]);
    final resolvedDate = _firstNonEmptyString([
          json['date'],
          resolvedStartDate,
          info?['Date'],
          info?['date'],
        ]) ??
        '';

    return EventModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: _firstNonEmptyString([json['title'], json['heading']]) ?? '',
      subtitle: _firstNonEmptyString([json['subtitle'], json['subHeading']]) ?? 'meet',
      date: resolvedDate,
      startDate: resolvedStartDate,
      endDate: resolvedEndDate,
      timezone: _firstNonEmptyString([json['timezone']]),
      time: _firstNonEmptyString([json['time'], info?['Time'], info?['time']]) ?? '9 PM',
      location: _firstNonEmptyString([json['location'], info?['Location'], info?['location']]) ?? '',
      organizer: _firstNonEmptyString([
            json['organizer'],
            info?['Organizers'],
            info?['Organizer'],
            info?['organizers'],
            info?['organizer'],
          ]) ??
          'Matrimony Team',
      description: _firstNonEmptyString([json['description']]) ?? '',
      status: _firstNonEmptyString([json['status']]) ?? 'upcoming',
      isCancelled: json['isCancelled'] == true ||
          json['isCanceled'] == true ||
          json['cancelled'] == true ||
          json['canceled'] == true,
      isDeleted: json['isDeleted'] == true ||
          json['deleted'] == true ||
          json['deletedAt'] != null,
      isActive: json['isActive'] != false && json['active'] != false,
      badgeText: _firstNonEmptyString([json['badgeText']]) ?? 'SOON',
      images: _extractImages(json),
      whatsappNumber: _firstNonEmptyString([json['whatsappNumber']]) ?? '919856543232',
    );
  }
}
