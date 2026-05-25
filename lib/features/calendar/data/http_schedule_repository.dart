import '../../../core/api/api_client.dart';
import '../domain/schedule_entry.dart';
import '../domain/schedule_repository.dart';

class HttpScheduleRepository implements ScheduleRepository {
  const HttpScheduleRepository(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<ScheduleEntry>> fetchSchedules({
    required String authorization,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final json = await _apiClient.getJsonList(
        '/api/schedules',
        authorization: authorization,
        queryParameters: {
          'from': from.toUtc().toIso8601String(),
          'to': to.toUtc().toIso8601String(),
        },
      );

      return json
          .cast<Map<String, Object?>>()
          .map(ScheduleEntry.fromJson)
          .toList(growable: false);
    } on ApiException catch (exception) {
      throw ScheduleFailure(exception.message);
    } catch (_) {
      throw const ScheduleFailure('Unable to load schedules.');
    }
  }

  @override
  Future<ScheduleEntry> createSchedule({
    required String authorization,
    required ScheduleDraft draft,
  }) async {
    try {
      final json = await _apiClient.postJson(
        '/api/schedules',
        {
          'title': draft.title,
          'startAt': draft.startAt.toUtc().toIso8601String(),
          'endAt': draft.endAt.toUtc().toIso8601String(),
          'memo': draft.memo,
        },
        authorization: authorization,
      );

      return ScheduleEntry.fromJson(json);
    } on ApiException catch (exception) {
      throw ScheduleFailure(exception.message);
    } catch (_) {
      throw const ScheduleFailure('Unable to save schedule.');
    }
  }
}
