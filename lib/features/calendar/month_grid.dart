import 'package:flutter/material.dart';

import 'schedule_preview.dart';

class MonthGrid extends StatelessWidget {
  const MonthGrid({
    required this.month,
    required this.selectedDay,
    required this.schedules,
    required this.onDaySelected,
    super.key,
  });

  final DateTime month;
  final int selectedDay;
  final List<SchedulePreview> schedules;
  final ValueChanged<int> onDaySelected;

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    final days = _buildDays(month);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 480;
        final gridPadding = isCompact ? 14.0 : 16.0;
        final gridSpacing = isCompact ? 6.0 : 8.0;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE6EAF0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 28,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(gridPadding),
            child: Column(
              children: [
                GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 2.4,
                  children: [
                    for (final weekday in _weekdays)
                      Center(
                        child: Text(
                          weekday,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: const Color(0xFF7B8494),
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: gridSpacing),
                GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: isCompact ? 0.9 : 1.05,
                  mainAxisSpacing: gridSpacing,
                  crossAxisSpacing: gridSpacing,
                  children: [
                    for (final day in days)
                      _DayCell(
                        day: day,
                        isSelected: day == selectedDay,
                        hasSchedule: schedules.any(
                          (schedule) => schedule.day == day,
                        ),
                        compact: isCompact,
                        onSelected:
                            day == null ? null : () => onDaySelected(day),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<int?> _buildDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingEmptyDays = firstDay.weekday - 1;

    return [
      for (var index = 0; index < leadingEmptyDays; index++) null,
      for (var day = 1; day <= daysInMonth; day++) day,
    ];
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.hasSchedule,
    required this.compact,
    required this.onSelected,
  });

  final int? day;
  final bool isSelected;
  final bool hasSchedule;
  final bool compact;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    if (day == null) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final foreground = isSelected ? Colors.white : const Color(0xFF1F2937);
    final fontSize = compact ? 16.0 : 17.0;
    final dotSpacing = compact ? 4.0 : 6.0;

    return InkWell(
      onTap: onSelected,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colorScheme.primary : const Color(0xFFE6EAF0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                color: foreground,
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: dotSpacing),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: hasSchedule
                    ? (isSelected ? Colors.white : colorScheme.secondary)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
