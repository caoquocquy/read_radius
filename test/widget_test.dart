import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/core/providers/startup_provider.dart';
import 'package:read_radius/features/wall/domain/wall_book.dart';
import 'package:read_radius/features/wall/providers/wall_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:read_radius/app/app.dart';

void main() {
  testWidgets('ReadRadius app shell renders wall search prompt', (
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
        child: const ReadRadiusApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ReadRadius'), findsOneWidget);
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
        child: const ReadRadiusApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('wall-grid-view')), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.byIcon(Icons.view_list_rounded), findsOneWidget);
  });

  testWidgets('Wall toggles between grid and list views', (
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
            (Ref ref) async => const <WallBook>[
              WallBook(
                id: 'book-1',
                title: 'Sample Book 1',
                authors: <String>['Author 1'],
                thumbnailUrl: null,
              ),
              WallBook(
                id: 'book-2',
                title: 'Sample Book 2',
                authors: <String>['Author 2'],
                thumbnailUrl: null,
              ),
            ],
          ),
        ],
        child: const ReadRadiusApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('wall-grid-view')), findsOneWidget);
    expect(find.byKey(const Key('wall-list-view')), findsNothing);

    await tester.tap(find.text('List'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('wall-list-view')), findsOneWidget);
    expect(find.byKey(const Key('wall-grid-view')), findsNothing);

    await tester.tap(find.text('Grid'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('wall-grid-view')), findsOneWidget);
    expect(find.byKey(const Key('wall-list-view')), findsNothing);
  });
}
