import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schedly_fe/app/schedly_app.dart';
import 'package:schedly_fe/features/auth/domain/auth_repository.dart';
import 'package:schedly_fe/features/auth/domain/auth_session.dart';

void main() {
  testWidgets('shows calendar first', (tester) async {
    await tester.pumpWidget(const SchedlyApp());

    expect(find.text('Schedly'), findsOneWidget);
    expect(find.text('May 2026'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('opens login and signup screens', (tester) async {
    await tester.pumpWidget(const SchedlyApp());

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Start with a simple profile.'), findsOneWidget);
  });

  testWidgets('submits login credentials to auth repository', (tester) async {
    final repository = _FakeAuthRepository();
    await tester.pumpWidget(SchedlyApp(authRepository: repository));

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(EditableText).at(0), 'owner@example.com');
    await tester.enterText(find.byType(EditableText).at(1), 'password123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(repository.loginEmail, 'owner@example.com');
    expect(repository.loginPassword, 'password123');
    expect(find.text('May 2026'), findsOneWidget);
  });

  testWidgets('shows signup failure from auth repository', (tester) async {
    final repository = _FakeAuthRepository(
      signupFailure: const AuthFailure('Email is already registered'),
    );
    await tester.pumpWidget(SchedlyApp(authRepository: repository));

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText).at(0), 'Owner');
    await tester.enterText(
        find.byType(EditableText).at(1), 'owner@example.com');
    await tester.enterText(find.byType(EditableText).at(2), 'password123');
    await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
    await tester.pumpAndSettle();

    expect(repository.signupEmail, 'owner@example.com');
    expect(find.text('Email is already registered'), findsOneWidget);
  });

  testWidgets('renders compact calendar without overflow', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const SchedlyApp());
    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();

    expect(find.text('No schedules'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    this.signupFailure,
  });

  final AuthFailure? signupFailure;

  String? loginEmail;
  String? loginPassword;
  String? signupName;
  String? signupEmail;
  String? signupPassword;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    loginEmail = email;
    loginPassword = password;

    return _session(email);
  }

  @override
  Future<AuthSession> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    signupName = name;
    signupEmail = email;
    signupPassword = password;

    final failure = signupFailure;
    if (failure != null) {
      throw failure;
    }

    return _session(email, name: name);
  }

  AuthSession _session(String email, {String name = 'Owner'}) {
    return AuthSession(
      tokenType: 'Bearer',
      accessToken: 'token',
      expiresInSeconds: 3600,
      user: AuthUser(
        id: 'user-id',
        email: email,
        name: name,
      ),
    );
  }
}
