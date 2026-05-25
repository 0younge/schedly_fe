class AuthSession {
  const AuthSession({
    required this.tokenType,
    required this.accessToken,
    required this.expiresInSeconds,
    required this.user,
  });

  final String tokenType;
  final String accessToken;
  final int expiresInSeconds;
  final AuthUser user;

  String get authorizationHeader => '$tokenType $accessToken';

  factory AuthSession.fromJson(Map<String, Object?> json) {
    return AuthSession(
      tokenType: json['tokenType'] as String,
      accessToken: json['accessToken'] as String,
      expiresInSeconds: json['expiresInSeconds'] as int,
      user: AuthUser.fromJson(json['user'] as Map<String, Object?>),
    );
  }
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
  });

  final String id;
  final String email;
  final String name;

  factory AuthUser.fromJson(Map<String, Object?> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }
}
