import 'package:flutter/material.dart';

import '../../app/app_routes.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({required this.monthLabel, super.key});

  final String monthLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Schedly', style: textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(monthLabel, style: textTheme.bodyMedium),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
          icon: const Icon(Icons.login_rounded),
          label: const Text('Login'),
        ),
      ],
    );
  }
}
