import 'package:read_radius/features/wall/domain/wall_book.dart';
import 'package:read_radius/features/wall/domain/wall_repository.dart';

class ExampleWallRepository implements WallRepository {
  ExampleWallRepository();

  static const List<WallBook> _books = <WallBook>[
    WallBook(
      id: 'example-1984',
      title: '1984',
      authors: <String>['George Orwell'],
      thumbnailUrl: null,
    ),
    WallBook(
      id: 'example-dune',
      title: 'Dune',
      authors: <String>['Frank Herbert'],
      thumbnailUrl: null,
    ),
    WallBook(
      id: 'example-hobbit',
      title: 'The Hobbit',
      authors: <String>['J. R. R. Tolkien'],
      thumbnailUrl: null,
    ),
    WallBook(
      id: 'example-atomic-habits',
      title: 'Atomic Habits',
      authors: <String>['James Clear'],
      thumbnailUrl: null,
    ),
    WallBook(
      id: 'example-clean-code',
      title: 'Clean Code',
      authors: <String>['Robert C. Martin'],
      thumbnailUrl: null,
    ),
    WallBook(
      id: 'example-sapiens',
      title: 'Sapiens',
      authors: <String>['Yuval Noah Harari'],
      thumbnailUrl: null,
    ),
    WallBook(
      id: 'example-pragmatic-programmer',
      title: 'The Pragmatic Programmer',
      authors: <String>['Andy Hunt', 'Dave Thomas'],
      thumbnailUrl: null,
    ),
    WallBook(
      id: 'example-deep-work',
      title: 'Deep Work',
      authors: <String>['Cal Newport'],
      thumbnailUrl: null,
    ),
    WallBook(
      id: 'example-alchemist',
      title: 'The Alchemist',
      authors: <String>['Paulo Coelho'],
      thumbnailUrl: null,
    ),
    WallBook(
      id: 'example-thinking-fast-and-slow',
      title: 'Thinking, Fast and Slow',
      authors: <String>['Daniel Kahneman'],
      thumbnailUrl: null,
    ),
  ];

  @override
  Future<List<WallBook>> searchBooks(String query) async {
    final String normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return <WallBook>[];
    }

    return _books
        .where((WallBook book) {
          final bool titleMatch = book.title.toLowerCase().contains(normalized);
          final bool authorMatch = book.authors.any(
            (String author) => author.toLowerCase().contains(normalized),
          );
          return titleMatch || authorMatch;
        })
        .toList(growable: false);
  }

  @override
  Future<List<WallBook>> fetchTrendingBooks() async {
    return _books.take(6).toList(growable: false);
  }
}
