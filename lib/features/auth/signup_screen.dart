import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import 'domain/auth_repository.dart';
import 'auth_shell.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
    required this.authRepository,
  });

  final AuthRepository authRepository;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Create account',
      subtitle: 'Start with a simple profile.',
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                validator: _required,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _required,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _passwordController,
                autofillHints: const [AutofillHints.newPassword],
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: _required,
                onFieldSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),
            ],
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 14),
          _AuthErrorText(_errorMessage!),
        ],
        const SizedBox(height: 22),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create account'),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.login,
                    ModalRoute.withName(AppRoutes.calendar),
                  ),
          child: const Text('Back to login'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await widget.authRepository.signup(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.calendar,
        (route) => false,
      );
    } on AuthFailure catch (exception) {
      _showError(exception.message);
    } catch (_) {
      _showError('Unable to create account. Please try again.');
    }
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    setState(() {
      _errorMessage = message;
      _isSubmitting = false;
    });
  }

  String? _required(String? value) {
    return value == null || value.trim().isEmpty ? 'Required' : null;
  }
}

class _AuthErrorText extends StatelessWidget {
  const _AuthErrorText(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
        color: Theme.of(context).colorScheme.error,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
