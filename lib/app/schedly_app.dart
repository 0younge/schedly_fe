import 'package:flutter/material.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/calendar/calendar_screen.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class SchedlyApp extends StatelessWidget {
  const SchedlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.calendar,
      routes: {
        AppRoutes.calendar: (_) => const CalendarScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.signup: (_) => const SignupScreen(),
      },
    );
  }
}
