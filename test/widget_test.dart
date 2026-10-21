import 'package:flutter_test/flutter_test.dart';
import 'package:testuts/main.dart';

void main() {
  testWidgets('App renders correctly smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title QuizMate renders
    expect(find.text('QuizMate'), findsOneWidget);
  });
}
