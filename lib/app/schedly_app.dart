import 'package:flutter/material.dart';

import '../core/api/api_client.dart';
import '../features/auth/data/http_auth_repository.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/auth/domain/auth_session_controller.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/calendar/calendar_screen.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class SchedlyApp extends StatefulWidget {
  const SchedlyApp({
    super.key,
    this.authRepository,
    this.authSessionController,
  });

  final AuthRepository? authRepository;
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
    final repository = widget.authRepository ?? HttpAuthRepository(ApiClient());

    return MaterialApp(
      title: 'Schedly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.calendar,
      routes: {
        AppRoutes.calendar: (_) => CalendarScreen(
              authSessionController: _authSessionController,
            ),
        AppRoutes.login: (_) => LoginScreen(
              authRepository: repository,
              authSessionController: _authSessionController,
            ),
        AppRoutes.signup: (_) => SignupScreen(
              authRepository: repository,
              authSessionController: _authSessionController,
            ),
      },
    );
  }
}
