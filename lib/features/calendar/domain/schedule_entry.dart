class ScheduleEntry {
  const ScheduleEntry({
    required this.id,
    required this.title,
    required this.startAt,
    required this.endAt,
    this.memo,
  });

  final String id;
  final String title;
  final DateTime startAt;
  final DateTime endAt;
  final String? memo;

  int get day => startAt.toLocal().day;

  String get timeLabel {
    final localStart = startAt.toLocal();
    final hour = localStart.hour.toString().padLeft(2, '0');
    final minute = localStart.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  factory ScheduleEntry.fromJson(Map<String, Object?> json) {
    return ScheduleEntry(
      id: json['id'] as String,
      title: json['title'] as String,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      memo: json['memo'] as String?,
    );
  }
}

class ScheduleDraft {
  const ScheduleDraft({
    required this.title,
    required this.startAt,
    required this.endAt,
    this.memo,
  });

  final String title;
  final DateTime startAt;
  final DateTime endAt;
  final String? memo;
}
