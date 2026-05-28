import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/shelves/providers/shelves_providers.dart';
import 'package:read_radius/features/shelves/domain/shelves_repository.dart';
import 'package:read_radius/features/shelves/presentation/shelves_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  const ShelfBook sampleBook = ShelfBook(
    bookId: 'book-1',
    title: 'Brave New World',
    authors: <String>['Aldous Huxley'],
    status: ShelfStatus.wantToRead,
  );

  const ShelfBook readingBook = ShelfBook(
    bookId: 'book-2',
    title: 'Dune',
    authors: <String>['Frank Herbert'],
    status: ShelfStatus.reading,
    currentPercent: 40,
  );

  const ShelfBook completedBook = ShelfBook(
    bookId: 'book-3',
    title: '1984',
    authors: <String>['George Orwell'],
    status: ShelfStatus.completed,
  );

  Widget buildShelvesApp({
    required AuthSessionState authState,
    required ShelvesByStatus shelves,
  }) {
    return ProviderScope(
      overrides: [
        authSessionProvider.overrideWith(
          (Ref ref) => Stream<AuthSessionState>.value(authState),
        ),
        authUserPhotoUrlProvider.overrideWith(
          (Ref ref) => Stream<String?>.value(null),
        ),
        shelvesByStatusProvider.overrideWith((Ref ref) async => shelves),
      ],
      child: const MaterialApp(home: ShelvesScreen()),
    );
  }

  testWidgets('guest sees placeholder with sign-in prompt', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildShelvesApp(
        authState: AuthSessionState.guest,
        shelves: emptyShelvesByStatus(),
      ),
    );

    expect(find.text('Sign in to see your shelves'), findsOneWidget);
    expect(find.text('Continue with Facebook'), findsOneWidget);
    expect(
      find.text('Track books across Want to Read, Reading, and Completed.'),
      findsOneWidget,
    );
  });

  testWidgets('guest tapping continue opens auth guard sheet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildShelvesApp(
        authState: AuthSessionState.guest,
        shelves: emptyShelvesByStatus(),
      ),
    );

    await tester.tap(find.text('Continue with Facebook'));
    await tester.pumpAndSettle();

    expect(find.text('Login with Facebook'), findsWidgets);
  });

  testWidgets('authenticated empty shelves shows empty message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildShelvesApp(
        authState: AuthSessionState.authenticated,
        shelves: emptyShelvesByStatus(),
      ),
    );

    expect(find.text('No books in your shelves yet.'), findsOneWidget);
    expect(find.text('No books yet.'), findsNothing);
  });

  testWidgets('authenticated shelves display books by status', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildShelvesApp(
        authState: AuthSessionState.authenticated,
        shelves: <ShelfStatus, List<ShelfBook>>{
          ShelfStatus.wantToRead: <ShelfBook>[sampleBook],
          ShelfStatus.reading: <ShelfBook>[readingBook],
          ShelfStatus.completed: <ShelfBook>[completedBook],
        },
      ),
    );

    expect(find.text('Want to Read'), findsOneWidget);
    expect(find.text('Reading'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Brave New World'), findsOneWidget);
    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('1984'), findsOneWidget);
  });

  testWidgets('reading book shows progress bar and percent', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildShelvesApp(
        authState: AuthSessionState.authenticated,
        shelves: <ShelfStatus, List<ShelfBook>>{
          ShelfStatus.wantToRead: const <ShelfBook>[],
          ShelfStatus.reading: <ShelfBook>[readingBook],
          ShelfStatus.completed: const <ShelfBook>[],
        },
      ),
    );

    expect(find.textContaining('40%'), findsOneWidget);
  });

  testWidgets('empty section shows no books placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildShelvesApp(
        authState: AuthSessionState.authenticated,
        shelves: <ShelfStatus, List<ShelfBook>>{
          ShelfStatus.wantToRead: <ShelfBook>[sampleBook],
          ShelfStatus.reading: const <ShelfBook>[],
          ShelfStatus.completed: const <ShelfBook>[],
        },
      ),
    );

    expect(find.text('No books yet.'), findsWidgets);
  });

  testWidgets('loading shelves shows loading indicator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionProvider.overrideWith(
            (Ref ref) =>
                Stream<AuthSessionState>.value(AuthSessionState.authenticated),
          ),
          authUserPhotoUrlProvider.overrideWith(
            (Ref ref) => Stream<String?>.value(null),
          ),
          shelvesByStatusProvider.overrideWith(
            (Ref ref) => Future<ShelvesByStatus>.delayed(
              const Duration(seconds: 10),
              () => emptyShelvesByStatus(),
            ),
          ),
        ],
        child: const MaterialApp(home: ShelvesScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
