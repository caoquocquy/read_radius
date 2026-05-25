import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:book_radius/app/app.dart';

void main() {
  testWidgets('BookRadius app shell renders guest placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: BookRadiusApp()));
    await tester.pumpAndSettle();

    expect(find.text('BookRadius'), findsOneWidget);
    expect(find.text('Guest Book Wall (Day 1 Placeholder)'), findsOneWidget);
  });
}
