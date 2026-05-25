import '../../../core/api/api_client.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_session.dart';

class HttpAuthRepository implements AuthRepository {
  const HttpAuthRepository(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) {
    return _submit(
      '/api/auth/login',
      {
        'email': email,
        'password': password,
      },
    );
  }

  @override
  Future<AuthSession> signup({
    required String name,
    required String email,
    required String password,
  }) {
    return _submit(
      '/api/auth/signup',
      {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  Future<AuthSession> _submit(
    String path,
    Map<String, Object?> body,
  ) async {
    try {
      final json = await _apiClient.postJson(path, body);
      return AuthSession.fromJson(json);
    } on ApiException catch (exception) {
      throw AuthFailure(exception.message);
    } catch (_) {
      throw const AuthFailure('Unable to reach Schedly. Please try again.');
    }
  }
}
