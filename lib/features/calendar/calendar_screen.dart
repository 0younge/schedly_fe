import 'package:flutter/material.dart';

import '../auth/domain/auth_session_controller.dart';
import 'calendar_header.dart';
import 'month_grid.dart';
import 'schedule_panel.dart';
import 'schedule_preview.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    required this.authSessionController,
  });

  final AuthSessionController authSessionController;

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

  final List<SchedulePreview> _schedules = const [
    SchedulePreview(day: 6, title: 'Design sync', time: '10:00'),
    SchedulePreview(day: 12, title: 'API contract', time: '14:30'),
    SchedulePreview(day: 22, title: 'Product review', time: '09:30'),
    SchedulePreview(day: 22, title: 'Sprint planning', time: '16:00'),
    SchedulePreview(day: 28, title: 'Release prep', time: '11:00'),
  ];

  @override
  Widget build(BuildContext context) {
    final monthName = _monthNames[_visibleMonth.month - 1];
    final monthLabel = '$monthName ${_visibleMonth.year}';
    final selectedSchedules = _schedules
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
                                  schedules: _schedules,
                                  selectedSchedules: selectedSchedules,
                                  onDaySelected: _selectDay,
                                )
                              : _WideCalendarBody(
                                  month: _visibleMonth,
                                  monthName: monthName,
                                  selectedDay: _selectedDay,
                                  schedules: _schedules,
                                  selectedSchedules: selectedSchedules,
                                  onDaySelected: _selectDay,
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
}

class _CompactCalendarBody extends StatelessWidget {
  const _CompactCalendarBody({
    required this.month,
    required this.monthName,
    required this.selectedDay,
    required this.schedules,
    required this.selectedSchedules,
    required this.onDaySelected,
  });

  final DateTime month;
  final String monthName;
  final int selectedDay;
  final List<SchedulePreview> schedules;
  final List<SchedulePreview> selectedSchedules;
  final ValueChanged<int> onDaySelected;

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
    required this.onDaySelected,
  });

  final DateTime month;
  final String monthName;
  final int selectedDay;
  final List<SchedulePreview> schedules;
  final List<SchedulePreview> selectedSchedules;
  final ValueChanged<int> onDaySelected;

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
          ),
        ),
      ],
    );
  }
}
