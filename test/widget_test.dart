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

    expect(find.text('Create account'), findsOneWidget);
  });
}
