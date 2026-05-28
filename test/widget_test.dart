import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/core/providers/startup_provider.dart';
import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/shelves/providers/shelves_providers.dart';
import 'package:read_radius/features/home/domain/home_book.dart';
import 'package:read_radius/features/home/providers/home_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:read_radius/app/app.dart';

void main() {
  testWidgets('ReadRadius app shell renders home search prompt', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          startupProvider.overrideWith((Ref ref) async {}),
          authSessionProvider.overrideWith(
            (Ref ref) => Stream<AuthSessionState>.value(AuthSessionState.guest),
          ),
          homeTrendingResultsProvider.overrideWith(
            (Ref ref) async => <HomeBook>[],
          ),
        ],
        child: const ReadRadiusApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Search books on Google Books'), findsOneWidget);
  });

  testWidgets('Home defaults to grid mode', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          startupProvider.overrideWith((Ref ref) async {}),
          authSessionProvider.overrideWith(
            (Ref ref) => Stream<AuthSessionState>.value(AuthSessionState.guest),
          ),
          homeTrendingResultsProvider.overrideWith(
            (Ref ref) async => const <HomeBook>[
              HomeBook(
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

    expect(find.byKey(const Key('home-grid-view')), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.byIcon(Icons.view_list_rounded), findsOneWidget);
  });

  testWidgets('Home toggles between grid and list views', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          startupProvider.overrideWith((Ref ref) async {}),
          authSessionProvider.overrideWith(
            (Ref ref) => Stream<AuthSessionState>.value(AuthSessionState.guest),
          ),
          homeTrendingResultsProvider.overrideWith(
            (Ref ref) async => const <HomeBook>[
              HomeBook(
                id: 'book-1',
                title: 'Sample Book 1',
                authors: <String>['Author 1'],
                thumbnailUrl: null,
              ),
              HomeBook(
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

    expect(find.byKey(const Key('home-grid-view')), findsOneWidget);
    expect(find.byKey(const Key('home-list-view')), findsNothing);

    // Toggle to list view by tapping the list icon on the segmented button
    await tester.tap(find.byIcon(Icons.view_list_rounded));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-list-view')), findsOneWidget);
    expect(find.byKey(const Key('home-grid-view')), findsNothing);

    // Toggle back to grid view by tapping the grid icon
    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home-grid-view')), findsOneWidget);
    expect(find.byKey(const Key('home-list-view')), findsNothing);
  });

  testWidgets('Tapping home book opens details screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          startupProvider.overrideWith((Ref ref) async {}),
          authSessionProvider.overrideWith(
            (Ref ref) => Stream<AuthSessionState>.value(AuthSessionState.guest),
          ),
          homeTrendingResultsProvider.overrideWith(
            (Ref ref) async => const <HomeBook>[
              HomeBook(
                id: 'example-1984',
                title: '1984',
                authors: <String>['George Orwell'],
                thumbnailUrl: null,
              ),
            ],
          ),
        ],
        child: const ReadRadiusApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('1984').first);
    await tester.pumpAndSettle();

    expect(find.text('1984'), findsWidgets);
    expect(find.text('George Orwell'), findsOneWidget);
    expect(find.text('Book Details'), findsOneWidget);
    expect(find.text('About this book'), findsOneWidget);
  });

  testWidgets('Tapping shelf book opens details screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          startupProvider.overrideWith((Ref ref) async {}),
          authSessionProvider.overrideWith(
            (Ref ref) =>
                Stream<AuthSessionState>.value(AuthSessionState.authenticated),
          ),
          shelvesByStatusProvider.overrideWith(
            (Ref ref) async => <ShelfStatus, List<ShelfBook>>{
              ShelfStatus.wantToRead: const <ShelfBook>[
                ShelfBook(
                  bookId: 'example-1984',
                  title: '1984',
                  authors: <String>['George Orwell'],
                  status: ShelfStatus.wantToRead,
                ),
              ],
              ShelfStatus.reading: const <ShelfBook>[],
              ShelfStatus.completed: const <ShelfBook>[],
            },
          ),
        ],
        child: const ReadRadiusApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('1984').first);
    await tester.pumpAndSettle();

    expect(find.text('1984'), findsWidgets);
    expect(find.text('George Orwell'), findsOneWidget);
    expect(find.text('Book Details'), findsOneWidget);
    expect(find.text('About this book'), findsOneWidget);
  });
}
