import 'package:flutter_test/flutter_test.dart';
import 'package:learnmateai/main.dart';

void main() {
  testWidgets('App should load splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LearnMateAI());

    // Verify that the splash screen text is present.
    expect(find.text('LearnMateAI'), findsOneWidget);
  });
}
