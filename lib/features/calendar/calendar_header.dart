import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../auth/domain/auth_session.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    required this.monthLabel,
    required this.session,
    required this.onLogout,
    super.key,
  });

  final String monthLabel;
  final AuthSession? session;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final session = this.session;

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
        if (session == null)
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
            icon: const Icon(Icons.login_rounded),
            label: const Text('Login'),
          )
        else
          _SignedInHeaderActions(
            name: session.user.name,
            email: session.user.email,
            onLogout: onLogout,
          ),
      ],
    );
  }
}

class _SignedInHeaderActions extends StatelessWidget {
  const _SignedInHeaderActions({
    required this.name,
    required this.email,
    required this.onLogout,
  });

  final String name;
  final String email;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        IconButton.filledTonal(
          tooltip: 'Logout',
          onPressed: onLogout,
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    );
  }
}
