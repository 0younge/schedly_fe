import 'package:flutter/material.dart';

import '../core/api/api_client.dart';
import '../features/auth/data/http_auth_repository.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/calendar/calendar_screen.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class SchedlyApp extends StatelessWidget {
  const SchedlyApp({
    super.key,
    this.authRepository,
  });

  final AuthRepository? authRepository;

  @override
  Widget build(BuildContext context) {
    final repository = authRepository ?? HttpAuthRepository(ApiClient());

    return MaterialApp(
      title: 'Schedly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.calendar,
      routes: {
        AppRoutes.calendar: (_) => const CalendarScreen(),
        AppRoutes.login: (_) => LoginScreen(authRepository: repository),
        AppRoutes.signup: (_) => SignupScreen(authRepository: repository),
      },
    );
  }
}
