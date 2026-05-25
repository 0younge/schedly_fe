import 'package:flutter/material.dart';

import '../core/api/api_client.dart';
import '../features/auth/data/http_auth_repository.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/auth/domain/auth_session_controller.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/calendar/data/http_schedule_repository.dart';
import '../features/calendar/calendar_screen.dart';
import '../features/calendar/domain/schedule_repository.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class SchedlyApp extends StatefulWidget {
  const SchedlyApp({
    super.key,
    this.authRepository,
    this.scheduleRepository,
    this.authSessionController,
  });

  final AuthRepository? authRepository;
  final ScheduleRepository? scheduleRepository;
  final AuthSessionController? authSessionController;

  @override
  State<SchedlyApp> createState() => _SchedlyAppState();
}

class _SchedlyAppState extends State<SchedlyApp> {
  late final AuthSessionController _authSessionController =
      widget.authSessionController ?? AuthSessionController();

  @override
  void dispose() {
    if (widget.authSessionController == null) {
      _authSessionController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final authRepository =
        widget.authRepository ?? HttpAuthRepository(apiClient);
    final scheduleRepository =
        widget.scheduleRepository ?? HttpScheduleRepository(apiClient);

    return MaterialApp(
      title: 'Schedly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.calendar,
      routes: {
        AppRoutes.calendar: (_) => CalendarScreen(
              authSessionController: _authSessionController,
              scheduleRepository: scheduleRepository,
            ),
        AppRoutes.login: (_) => LoginScreen(
              authRepository: authRepository,
              authSessionController: _authSessionController,
            ),
        AppRoutes.signup: (_) => SignupScreen(
              authRepository: authRepository,
              authSessionController: _authSessionController,
            ),
      },
    );
  }
}
