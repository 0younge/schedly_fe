import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:schedly_fe/app/schedly_app.dart';

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
