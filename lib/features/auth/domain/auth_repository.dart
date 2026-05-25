import 'auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession> login({
    required String email,
    required String password,
  });

  Future<AuthSession> signup({
    required String name,
    required String email,
    required String password,
  });
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
