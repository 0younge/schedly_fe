import 'package:flutter/material.dart';

import '../auth/domain/auth_session_controller.dart';
import 'calendar_header.dart';
import 'domain/schedule_entry.dart';
import 'domain/schedule_repository.dart';
import 'month_grid.dart';
import 'schedule_panel.dart';
import 'schedule_preview.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    required this.authSessionController,
    required this.scheduleRepository,
  });

  final AuthSessionController authSessionController;
  final ScheduleRepository scheduleRepository;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final DateTime _visibleMonth = DateTime(2026, 5);
  int _selectedDay = 22;
  var _remoteSchedules = <ScheduleEntry>[];
  var _isLoadingSchedules = false;
  String? _scheduleError;

  final List<SchedulePreview> _schedules = const [
    SchedulePreview(day: 6, title: 'Design sync', time: '10:00'),
    SchedulePreview(day: 12, title: 'API contract', time: '14:30'),
    SchedulePreview(day: 22, title: 'Product review', time: '09:30'),
    SchedulePreview(day: 22, title: 'Sprint planning', time: '16:00'),
    SchedulePreview(day: 28, title: 'Release prep', time: '11:00'),
  ];

  @override
  void initState() {
    super.initState();
    widget.authSessionController.addListener(_handleSessionChanged);
    if (widget.authSessionController.isSignedIn) {
      _loadSchedules();
    }
  }

  @override
  void dispose() {
    widget.authSessionController.removeListener(_handleSessionChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _monthNames[_visibleMonth.month - 1];
    final monthLabel = '$monthName ${_visibleMonth.year}';
    final isSignedIn = widget.authSessionController.isSignedIn;
    final schedules = isSignedIn ? _remotePreviews : _schedules;
    final selectedSchedules = schedules
        .where((schedule) => schedule.day == _selectedDay)
        .toList(growable: false);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedBuilder(
                    animation: widget.authSessionController,
                    builder: (context, _) {
                      return CalendarHeader(
                        monthLabel: monthLabel,
                        session: widget.authSessionController.session,
                        onLogout: widget.authSessionController.signOut,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isCompact = constraints.maxWidth < 760;

                        return SingleChildScrollView(
                          child: isCompact
                              ? _CompactCalendarBody(
                                  month: _visibleMonth,
                                  monthName: monthName,
                                  selectedDay: _selectedDay,
                                  schedules: schedules,
                                  selectedSchedules: selectedSchedules,
                                  canAddSchedule: isSignedIn,
                                  isLoading: _isLoadingSchedules,
                                  errorMessage: _scheduleError,
                                  onDaySelected: _selectDay,
                                  onAddSchedule: _openCreateScheduleDialog,
                                )
                              : _WideCalendarBody(
                                  month: _visibleMonth,
                                  monthName: monthName,
                                  selectedDay: _selectedDay,
                                  schedules: schedules,
                                  selectedSchedules: selectedSchedules,
                                  canAddSchedule: isSignedIn,
                                  isLoading: _isLoadingSchedules,
                                  errorMessage: _scheduleError,
                                  onDaySelected: _selectDay,
                                  onAddSchedule: _openCreateScheduleDialog,
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectDay(int day) {
    setState(() {
      _selectedDay = day;
    });
  }

  List<SchedulePreview> get _remotePreviews {
    return _remoteSchedules
        .map(
          (schedule) => SchedulePreview(
            day: schedule.day,
            title: schedule.title,
            time: schedule.timeLabel,
          ),
        )
        .toList(growable: false);
  }

  void _handleSessionChanged() {
    if (!widget.authSessionController.isSignedIn) {
      setState(() {
        _remoteSchedules = [];
        _isLoadingSchedules = false;
        _scheduleError = null;
      });
      return;
    }

    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final session = widget.authSessionController.session;
    if (session == null) {
      return;
    }

    setState(() {
      _isLoadingSchedules = true;
      _scheduleError = null;
    });

    try {
      final schedules = await widget.scheduleRepository.fetchSchedules(
        authorization: session.authorizationHeader,
        from: DateTime(_visibleMonth.year, _visibleMonth.month),
        to: DateTime(_visibleMonth.year, _visibleMonth.month + 1),
      );

      if (!mounted || widget.authSessionController.session != session) {
        return;
      }

      setState(() {
        _remoteSchedules = _sortedSchedules(schedules);
        _isLoadingSchedules = false;
      });
    } on ScheduleFailure catch (exception) {
      _showScheduleError(exception.message);
    } catch (_) {
      _showScheduleError('Unable to load schedules.');
    }
  }

  Future<void> _openCreateScheduleDialog() async {
    final session = widget.authSessionController.session;
    if (session == null) {
      return;
    }

    final draft = await showDialog<ScheduleDraft>(
      context: context,
      builder: (context) => _ScheduleFormDialog(
        selectedDate: DateTime(
          _visibleMonth.year,
          _visibleMonth.month,
          _selectedDay,
        ),
      ),
    );
    if (draft == null) {
      return;
    }

    setState(() {
      _isLoadingSchedules = true;
      _scheduleError = null;
    });

    try {
      final schedule = await widget.scheduleRepository.createSchedule(
        authorization: session.authorizationHeader,
        draft: draft,
      );

      if (!mounted || widget.authSessionController.session != session) {
        return;
      }

      setState(() {
        _remoteSchedules = _sortedSchedules([..._remoteSchedules, schedule]);
        _isLoadingSchedules = false;
      });
    } on ScheduleFailure catch (exception) {
      _showScheduleError(exception.message);
    } catch (_) {
      _showScheduleError('Unable to save schedule.');
    }
  }

  void _showScheduleError(String message) {
    if (!mounted) {
      return;
    }

    setState(() {
      _scheduleError = message;
      _isLoadingSchedules = false;
    });
  }

  List<ScheduleEntry> _sortedSchedules(List<ScheduleEntry> schedules) {
    return [...schedules]
      ..sort((left, right) => left.startAt.compareTo(right.startAt));
  }
}

class _CompactCalendarBody extends StatelessWidget {
  const _CompactCalendarBody({
    required this.month,
    required this.monthName,
    required this.selectedDay,
    required this.schedules,
    required this.selectedSchedules,
    required this.canAddSchedule,
    required this.isLoading,
    required this.errorMessage,
    required this.onDaySelected,
    required this.onAddSchedule,
  });

  final DateTime month;
  final String monthName;
  final int selectedDay;
  final List<SchedulePreview> schedules;
  final List<SchedulePreview> selectedSchedules;
  final bool canAddSchedule;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<int> onDaySelected;
  final VoidCallback onAddSchedule;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MonthGrid(
          month: month,
          selectedDay: selectedDay,
          schedules: schedules,
          onDaySelected: onDaySelected,
        ),
        const SizedBox(height: 16),
        SchedulePanel(
          monthName: monthName,
          selectedDay: selectedDay,
          schedules: selectedSchedules,
          canAddSchedule: canAddSchedule,
          isLoading: isLoading,
          errorMessage: errorMessage,
          onAddSchedule: onAddSchedule,
        ),
      ],
    );
  }
}

class _WideCalendarBody extends StatelessWidget {
  const _WideCalendarBody({
    required this.month,
    required this.monthName,
    required this.selectedDay,
    required this.schedules,
    required this.selectedSchedules,
    required this.canAddSchedule,
    required this.isLoading,
    required this.errorMessage,
    required this.onDaySelected,
    required this.onAddSchedule,
  });

  final DateTime month;
  final String monthName;
  final int selectedDay;
  final List<SchedulePreview> schedules;
  final List<SchedulePreview> selectedSchedules;
  final bool canAddSchedule;
  final bool isLoading;
  final String? errorMessage;
  final ValueChanged<int> onDaySelected;
  final VoidCallback onAddSchedule;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: MonthGrid(
            month: month,
            selectedDay: selectedDay,
            schedules: schedules,
            onDaySelected: onDaySelected,
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 320,
          child: SchedulePanel(
            monthName: monthName,
            selectedDay: selectedDay,
            schedules: selectedSchedules,
            canAddSchedule: canAddSchedule,
            isLoading: isLoading,
            errorMessage: errorMessage,
            onAddSchedule: onAddSchedule,
          ),
        ),
      ],
    );
  }
}

class _ScheduleFormDialog extends StatefulWidget {
  const _ScheduleFormDialog({required this.selectedDate});

  final DateTime selectedDate;

  @override
  State<_ScheduleFormDialog> createState() => _ScheduleFormDialogState();
}

class _ScheduleFormDialogState extends State<_ScheduleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _startController = TextEditingController(text: '09:00');
  final _endController = TextEditingController(text: '10:00');
  final _memoController = TextEditingController();
  String? _timeError;

  @override
  void dispose() {
    _titleController.dispose();
    _startController.dispose();
    _endController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add schedule'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 360,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                validator: _required,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.event_note_rounded),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _startController,
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      validator: _required,
                      decoration: const InputDecoration(
                        labelText: 'Start',
                        prefixIcon: Icon(Icons.schedule_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _endController,
                      keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      validator: _required,
                      decoration: const InputDecoration(
                        labelText: 'End',
                      ),
                    ),
                  ),
                ],
              ),
              if (_timeError != null) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _timeError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              TextFormField(
                controller: _memoController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Memo',
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.check_rounded),
          label: const Text('Save'),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final start = _parseTime(_startController.text);
    final end = _parseTime(_endController.text);
    if (start == null || end == null) {
      setState(() => _timeError = 'Use HH:mm');
      return;
    }

    final startAt = _combine(start);
    final endAt = _combine(end);
    if (!endAt.isAfter(startAt)) {
      setState(() => _timeError = 'End must be later');
      return;
    }

    Navigator.of(context).pop(
      ScheduleDraft(
        title: _titleController.text.trim(),
        startAt: startAt,
        endAt: endAt,
        memo: _memoController.text.trim().isEmpty
            ? null
            : _memoController.text.trim(),
      ),
    );
  }

  DateTime _combine(TimeOfDay time) {
    return DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      time.hour,
      time.minute,
    );
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty ? 'Required' : null;
  }

  TimeOfDay? _parseTime(String value) {
    final parts = value.trim().split(':');
    if (parts.length != 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return null;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }
}
