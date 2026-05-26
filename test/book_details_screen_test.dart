import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/presentation/auth_guard_sheet.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/home/domain/home_book_details.dart';
import 'package:read_radius/features/home/presentation/book_details_screen.dart';
import 'package:read_radius/features/home/providers/home_providers.dart';
import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const HomeBookDetails details = HomeBookDetails(
    id: 'book-1',
    title: 'Brave New World',
    authors: <String>['Aldous Huxley'],
    description: 'A classic dystopian novel.',
    pageCount: 311,
    publishedDate: '1932-01-01',
    categories: <String>['Fiction', 'Classics'],
    publisher: 'Chatto & Windus',
    previewLink: 'https://books.google.com/',
  );

  testWidgets('book details renders metadata and sections', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionProvider.overrideWith(
            (Ref ref) => Stream<AuthSessionState>.value(AuthSessionState.guest),
          ),
          homeBookDetailsProvider(
            'book-1',
          ).overrideWith((Ref ref) async => details),
          homeBookStatusProvider(
            'book-1',
          ).overrideWith((Ref ref) async => null),
          homeShelfBookProvider('book-1').overrideWith((Ref ref) async => null),
        ],
        child: const MaterialApp(home: BookDetailsScreen(bookId: 'book-1')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Book Details'), findsOneWidget);
    expect(find.text('Brave New World'), findsOneWidget);
    expect(find.text('Aldous Huxley'), findsOneWidget);
    expect(find.text('Publisher: Chatto & Windus'), findsOneWidget);
    expect(find.text('Published: 1932-01-01'), findsOneWidget);
    expect(find.text('Pages: 311'), findsOneWidget);
    expect(find.text('Fiction'), findsOneWidget);
    expect(find.text('Classics'), findsOneWidget);
    expect(find.text('About this book'), findsOneWidget);
    expect(find.text('A classic dystopian novel.'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Reviews'), 200);
    await tester.pumpAndSettle();
    expect(find.text('Reviews'), findsOneWidget);
    expect(find.text('Open Google Books Preview'), findsOneWidget);
    expect(find.text('Write Review'), findsOneWidget);
  });

  testWidgets('guest tapping shelf action opens auth guard sheet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionProvider.overrideWith(
            (Ref ref) => Stream<AuthSessionState>.value(AuthSessionState.guest),
          ),
          homeBookDetailsProvider(
            'book-1',
          ).overrideWith((Ref ref) async => details),
          homeBookStatusProvider(
            'book-1',
          ).overrideWith((Ref ref) async => null),
          homeShelfBookProvider('book-1').overrideWith((Ref ref) async => null),
        ],
        child: const MaterialApp(home: BookDetailsScreen(bookId: 'book-1')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Want to Read'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthGuardSheet), findsOneWidget);
    expect(find.text('Login with Facebook'), findsWidgets);
  });

  testWidgets('reading status shows progress card and percent', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionProvider.overrideWith(
            (Ref ref) =>
                Stream<AuthSessionState>.value(AuthSessionState.authenticated),
          ),
          homeBookDetailsProvider(
            'book-1',
          ).overrideWith((Ref ref) async => details),
          homeBookStatusProvider(
            'book-1',
          ).overrideWith((Ref ref) async => ShelfStatus.reading),
          homeShelfBookProvider('book-1').overrideWith(
            (Ref ref) async => const ShelfBook(
              bookId: 'book-1',
              title: 'Brave New World',
              authors: <String>['Aldous Huxley'],
              status: ShelfStatus.reading,
              currentPercent: 40,
            ),
          ),
        ],
        child: const MaterialApp(home: BookDetailsScreen(bookId: 'book-1')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Reading Progress'), findsOneWidget);
    expect(find.text('Current progress: 40%'), findsOneWidget);
    expect(find.text('Update Progress'), findsOneWidget);
  });

  testWidgets('authenticated tapping write review shows snackbar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionProvider.overrideWith(
            (Ref ref) =>
                Stream<AuthSessionState>.value(AuthSessionState.authenticated),
          ),
          homeBookDetailsProvider(
            'book-1',
          ).overrideWith((Ref ref) async => details),
          homeBookStatusProvider(
            'book-1',
          ).overrideWith((Ref ref) async => null),
          homeShelfBookProvider('book-1').overrideWith((Ref ref) async => null),
        ],
        child: const MaterialApp(home: BookDetailsScreen(bookId: 'book-1')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Write Review'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Write Review'));
    await tester.pump();

    expect(find.text('Write review is coming soon.'), findsOneWidget);
  });
}
