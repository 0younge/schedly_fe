import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import 'auth_shell.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Create account',
      subtitle: 'Start with a simple profile.',
      children: [
        const TextField(
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
        ),
        const SizedBox(height: 14),
        const TextField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.mail_outline_rounded),
          ),
        ),
        const SizedBox(height: 14),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock_outline_rounded),
          ),
        ),
        const SizedBox(height: 22),
        FilledButton(
          onPressed: () {},
          child: const Text('Create account'),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.login,
            ModalRoute.withName(AppRoutes.calendar),
          ),
          child: const Text('Back to login'),
        ),
      ],
    );
  }
}
