// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:ipo_app/main.dart';

void main() {
  testWidgets('IPO Tracker app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const IpoTrackerApp());

    // Verify that the app loads with bottom navigation
    expect(find.text('Ongoing'), findsOneWidget);
    expect(find.text('Upcoming'), findsOneWidget);
    expect(find.text('Closed'), findsOneWidget);

    // Verify that we can see the ongoing IPOs tab is selected
    await tester.pumpAndSettle();
    expect(find.text('Ongoing IPOs'), findsOneWidget);
  });
}
