import 'package:book_radius/features/auth/domain/auth_session_state.dart';
import 'package:book_radius/features/auth/providers/auth_providers.dart';
import 'package:book_radius/core/providers/startup_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:book_radius/app/app.dart';

void main() {
  testWidgets('BookRadius app shell renders guest placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          startupProvider.overrideWith((Ref ref) async {}),
          authSessionProvider.overrideWith(
            (Ref ref) => Stream<AuthSessionState>.value(AuthSessionState.guest),
          ),
        ],
        child: const BookRadiusApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('BookRadius'), findsOneWidget);
    expect(find.text('Wall (Day 1 Placeholder)'), findsOneWidget);
  });
}
