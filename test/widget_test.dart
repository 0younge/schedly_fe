import 'package:flutter_test/flutter_test.dart';
import 'package:schedly_fe/main.dart';

void main() {
  testWidgets('shows app name', (tester) async {
    await tester.pumpWidget(const SchedlyApp());

    expect(find.text('Schedly'), findsOneWidget);
  });
}
