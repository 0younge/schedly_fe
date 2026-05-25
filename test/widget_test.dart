import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:schedly_fe/app/schedly_app.dart';
import 'package:schedly_fe/features/auth/domain/auth_repository.dart';
import 'package:schedly_fe/features/auth/domain/auth_session.dart';
import 'package:schedly_fe/features/calendar/domain/schedule_entry.dart';
import 'package:schedly_fe/features/calendar/domain/schedule_repository.dart';

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
    final authRepository = _FakeAuthRepository();
    final scheduleRepository = _FakeScheduleRepository(
      schedules: [
        ScheduleEntry(
          id: 'schedule-id',
          title: 'Backend standup',
          startAt: DateTime(2026, 5, 22, 9),
          endAt: DateTime(2026, 5, 22, 10),
        ),
      ],
    );
    await tester.pumpWidget(
      SchedlyApp(
        authRepository: authRepository,
        scheduleRepository: scheduleRepository,
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(EditableText).at(0), 'owner@example.com');
    await tester.enterText(find.byType(EditableText).at(1), 'password123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(authRepository.loginEmail, 'owner@example.com');
    expect(authRepository.loginPassword, 'password123');
    expect(scheduleRepository.fetchAuthorization, 'Bearer token');
    expect(find.text('May 2026'), findsOneWidget);
    expect(find.text('Owner'), findsOneWidget);
    expect(find.text('owner@example.com'), findsOneWidget);
    expect(find.text('Login'), findsNothing);
    expect(find.text('Backend standup'), findsOneWidget);
  });

  testWidgets('logs out and shows login action again', (tester) async {
    final authRepository = _FakeAuthRepository();
    final scheduleRepository = _FakeScheduleRepository();
    await tester.pumpWidget(
      SchedlyApp(
        authRepository: authRepository,
        scheduleRepository: scheduleRepository,
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(EditableText).at(0), 'owner@example.com');
    await tester.enterText(find.byType(EditableText).at(1), 'password123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Owner'), findsNothing);
  });

  testWidgets('creates schedule for signed-in user', (tester) async {
    final authRepository = _FakeAuthRepository();
    final scheduleRepository = _FakeScheduleRepository();
    await tester.pumpWidget(
      SchedlyApp(
        authRepository: authRepository,
        scheduleRepository: scheduleRepository,
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byType(EditableText).at(0), 'owner@example.com');
    await tester.enterText(find.byType(EditableText).at(1), 'password123');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('15'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byTooltip('Add schedule'));
    await tester.tap(find.byTooltip('Add schedule'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText).at(0), 'Planning');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(scheduleRepository.createAuthorization, 'Bearer token');
    expect(scheduleRepository.createdDraft?.title, 'Planning');
    expect(scheduleRepository.createdDraft?.startAt.day, 15);
    expect(find.text('Planning'), findsOneWidget);
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

class _FakeScheduleRepository implements ScheduleRepository {
  _FakeScheduleRepository({
    List<ScheduleEntry> schedules = const [],
  }) : schedules = [...schedules];

  final List<ScheduleEntry> schedules;

  String? fetchAuthorization;
  String? createAuthorization;
  ScheduleDraft? createdDraft;

  @override
  Future<List<ScheduleEntry>> fetchSchedules({
    required String authorization,
    required DateTime from,
    required DateTime to,
  }) async {
    fetchAuthorization = authorization;
    return schedules;
  }

  @override
  Future<ScheduleEntry> createSchedule({
    required String authorization,
    required ScheduleDraft draft,
  }) async {
    createAuthorization = authorization;
    createdDraft = draft;

    final schedule = ScheduleEntry(
      id: 'created-schedule-id',
      title: draft.title,
      startAt: draft.startAt,
      endAt: draft.endAt,
      memo: draft.memo,
    );
    schedules.add(schedule);
    return schedule;
  }
}
