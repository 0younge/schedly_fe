import 'schedule_entry.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleEntry>> fetchSchedules({
    required String authorization,
    required DateTime from,
    required DateTime to,
  });

  Future<ScheduleEntry> createSchedule({
    required String authorization,
    required ScheduleDraft draft,
  });
}

class ScheduleFailure implements Exception {
  const ScheduleFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
