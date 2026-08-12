class EventModel {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String time;
  final String location;
  final String organizer;
  final String description;
  final String status; // 'upcoming' or 'past'
  final String badgeText;
  final List<String> images;
  final String whatsappNumber;

  const EventModel({
    required this.id,
    required this.title,
    this.subtitle = 'meet',
    required this.date,
    this.time = '9 PM',
    required this.location,
    this.organizer = 'Matrimony Team',
    required this.description,
    required this.status,
    this.badgeText = 'SOON',
    required this.images,
    this.whatsappNumber = '919856543232',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'date': date,
        'time': time,
        'location': location,
        'organizer': organizer,
        'description': description,
        'status': status,
        'badgeText': badgeText,
        'images': images,
        'whatsappNumber': whatsappNumber,
      };

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        title: json['title'] as String? ?? '',
        subtitle: json['subtitle'] as String? ?? 'meet',
        date: json['date'] as String? ?? '',
        time: json['time'] as String? ?? '9 PM',
        location: json['location'] as String? ?? '',
        organizer: json['organizer'] as String? ?? 'Matrimony Team',
        description: json['description'] as String? ?? '',
        status: json['status'] as String? ?? 'upcoming',
        badgeText: json['badgeText'] as String? ?? 'SOON',
        images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        whatsappNumber: json['whatsappNumber'] as String? ?? '919856543232',
      );
}
