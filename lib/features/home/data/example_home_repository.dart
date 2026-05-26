import 'package:read_radius/features/home/domain/home_book.dart';
import 'package:read_radius/features/home/domain/home_book_details.dart';
import 'package:read_radius/features/home/domain/home_repository.dart';

class ExampleHomeRepository implements HomeRepository {
  ExampleHomeRepository();

  static const List<HomeBook> _books = <HomeBook>[
    HomeBook(
      id: 'example-1984',
      title: '1984',
      authors: <String>['George Orwell'],
      thumbnailUrl: null,
    ),
    HomeBook(
      id: 'example-dune',
      title: 'Dune',
      authors: <String>['Frank Herbert'],
      thumbnailUrl: null,
    ),
    HomeBook(
      id: 'example-hobbit',
      title: 'The Hobbit',
      authors: <String>['J. R. R. Tolkien'],
      thumbnailUrl: null,
    ),
    HomeBook(
      id: 'example-atomic-habits',
      title: 'Atomic Habits',
      authors: <String>['James Clear'],
      thumbnailUrl: null,
    ),
    HomeBook(
      id: 'example-clean-code',
      title: 'Clean Code',
      authors: <String>['Robert C. Martin'],
      thumbnailUrl: null,
    ),
    HomeBook(
      id: 'example-sapiens',
      title: 'Sapiens',
      authors: <String>['Yuval Noah Harari'],
      thumbnailUrl: null,
    ),
    HomeBook(
      id: 'example-pragmatic-programmer',
      title: 'The Pragmatic Programmer',
      authors: <String>['Andy Hunt', 'Dave Thomas'],
      thumbnailUrl: null,
    ),
    HomeBook(
      id: 'example-deep-work',
      title: 'Deep Work',
      authors: <String>['Cal Newport'],
      thumbnailUrl: null,
    ),
    HomeBook(
      id: 'example-alchemist',
      title: 'The Alchemist',
      authors: <String>['Paulo Coelho'],
      thumbnailUrl: null,
    ),
    HomeBook(
      id: 'example-thinking-fast-and-slow',
      title: 'Thinking, Fast and Slow',
      authors: <String>['Daniel Kahneman'],
      thumbnailUrl: null,
    ),
  ];

  @override
  Future<List<HomeBook>> searchBooks(String query) async {
    final String normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return <HomeBook>[];
    }

    return _books
        .where((HomeBook book) {
          final bool titleMatch = book.title.toLowerCase().contains(normalized);
          final bool authorMatch = book.authors.any(
            (String author) => author.toLowerCase().contains(normalized),
          );
          return titleMatch || authorMatch;
        })
        .toList(growable: false);
  }

  @override
  Future<List<HomeBook>> fetchTrendingBooks() async {
    return _books.take(6).toList(growable: false);
  }

  @override
  Future<HomeBookDetails> fetchBookDetails(String bookId) async {
    final String normalizedId = bookId.trim();
    if (normalizedId.isEmpty) {
      throw const FormatException('Book id cannot be empty.');
    }

    final HomeBook? summary = _findBook(normalizedId);
    final HomeBookDetails? seeded = _detailsById[normalizedId];
    if (seeded != null) {
      return seeded;
    }

    return HomeBookDetails(
      id: normalizedId,
      title: summary?.title ?? normalizedId,
      authors: summary?.authors ?? const <String>[],
      thumbnailUrl: summary?.thumbnailUrl,
      description: 'No description is available yet for this sample book.',
      categories: const <String>['Sample'],
      publisher: 'Example Publisher',
    );
  }

  HomeBook? _findBook(String id) {
    for (final HomeBook book in _books) {
      if (book.id == id) {
        return book;
      }
    }
    return null;
  }

  static const Map<String, HomeBookDetails>
  _detailsById = <String, HomeBookDetails>{
    'example-1984': HomeBookDetails(
      id: 'example-1984',
      title: '1984',
      authors: <String>['George Orwell'],
      description: 'A dystopian novel about surveillance, control, and truth.',
      publishedDate: '1949',
      categories: <String>['Dystopian', 'Classic'],
      publisher: 'Secker & Warburg',
    ),
    'example-dune': HomeBookDetails(
      id: 'example-dune',
      title: 'Dune',
      authors: <String>['Frank Herbert'],
      description:
          'An epic science fiction story of politics, ecology, and destiny.',
      publishedDate: '1965',
      categories: <String>['Science Fiction'],
      publisher: 'Chilton Books',
    ),
    'example-hobbit': HomeBookDetails(
      id: 'example-hobbit',
      title: 'The Hobbit',
      authors: <String>['J. R. R. Tolkien'],
      description:
          'Bilbo Baggins leaves the Shire for an unforgettable adventure.',
      publishedDate: '1937',
      categories: <String>['Fantasy'],
      publisher: 'George Allen & Unwin',
    ),
  };
}
