import 'package:flutter/material.dart';

import 'schedule_preview.dart';

class SchedulePanel extends StatelessWidget {
  const SchedulePanel({
    required this.monthName,
    required this.selectedDay,
    required this.schedules,
    required this.canAddSchedule,
    required this.isLoading,
    required this.errorMessage,
    required this.onAddSchedule,
    super.key,
  });

  final String monthName;
  final int selectedDay;
  final List<SchedulePreview> schedules;
  final bool canAddSchedule;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onAddSchedule;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$monthName $selectedDay',
                    style: textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ),
                if (canAddSchedule)
                  IconButton.filledTonal(
                    tooltip: 'Add schedule',
                    onPressed: isLoading ? null : onAddSchedule,
                    icon: const Icon(Icons.add_rounded),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(
                child: SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (errorMessage != null)
              Text(
                errorMessage!,
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFFCA5A5),
                  fontWeight: FontWeight.w700,
                ),
              )
            else if (schedules.isEmpty)
              Text(
                'No schedules',
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFBAC3D0),
                ),
              )
            else
              for (final schedule in schedules) ...[
                _ScheduleItem(schedule: schedule),
                if (schedule != schedules.last) const SizedBox(height: 12),
              ],
          ],
        ),
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({required this.schedule});

  final SchedulePreview schedule;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF14B8A6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Text(
                  schedule.time,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                schedule.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
