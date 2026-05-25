import 'package:book_radius/features/auth/domain/auth_session_state.dart';
import 'package:book_radius/features/auth/providers/auth_providers.dart';
import 'package:book_radius/core/providers/startup_provider.dart';
import 'package:book_radius/features/wall/domain/wall_book.dart';
import 'package:book_radius/features/wall/providers/wall_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:book_radius/app/app.dart';

void main() {
  testWidgets('BookRadius app shell renders wall search prompt', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          startupProvider.overrideWith((Ref ref) async {}),
          authSessionProvider.overrideWith(
            (Ref ref) => Stream<AuthSessionState>.value(AuthSessionState.guest),
          ),
          wallTrendingResultsProvider.overrideWith(
            (Ref ref) async => <WallBook>[],
          ),
        ],
        child: const BookRadiusApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('BookRadius'), findsOneWidget);
    expect(find.text('Search books on Google Books'), findsOneWidget);
  });

  testWidgets('Wall defaults to grid mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          startupProvider.overrideWith((Ref ref) async {}),
          authSessionProvider.overrideWith(
            (Ref ref) => Stream<AuthSessionState>.value(AuthSessionState.guest),
          ),
          wallTrendingResultsProvider.overrideWith(
            (Ref ref) async => const <WallBook>[
              WallBook(
                id: 'book-1',
                title: 'Sample Book',
                authors: <String>['Sample Author'],
                thumbnailUrl: null,
              ),
            ],
          ),
        ],
        child: const BookRadiusApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('wall-grid-view')), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.byIcon(Icons.view_list_rounded), findsOneWidget);
  });
}
