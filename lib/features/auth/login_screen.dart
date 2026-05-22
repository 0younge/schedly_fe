import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import 'auth_shell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Welcome back',
      subtitle: 'Sign in to continue.',
      children: [
        const TextField(
          keyboardType: TextInputType.emailAddress,
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
          child: const Text('Login'),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signup),
          icon: const Icon(Icons.person_add_alt_1_rounded),
          label: const Text('Sign up'),
        ),
      ],
    );
  }
}
