import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/shelves/domain/shelves_repository.dart';
import 'package:read_radius/features/shelves/providers/shelves_providers.dart';
import 'package:read_radius/features/home/data/example_home_repository.dart';
import 'package:read_radius/features/home/data/google_books_home_repository.dart';
import 'package:read_radius/features/home/domain/home_book.dart';
import 'package:read_radius/features/home/domain/home_book_details.dart';
import 'package:read_radius/features/home/domain/home_repository.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

enum HomeBooksViewMode { grid, list }

const bool enableHomeExampleData = true;

@riverpod
class HomeLocalBookStatuses extends _$HomeLocalBookStatuses {
  @override
  Map<String, ShelfStatus> build() => <String, ShelfStatus>{};

  void setStatus(String bookId, ShelfStatus status) {
    state = <String, ShelfStatus>{...state, bookId: status};
  }
}

@riverpod
http.Client homeHttpClient(Ref ref) {
  final http.Client client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@riverpod
HomeRepository homeRepository(Ref ref) {
  if (enableHomeExampleData) {
    return ExampleHomeRepository();
  }

  return GoogleBooksHomeRepository(
    ref.watch(homeHttpClientProvider),
    apiKey: const String.fromEnvironment('GOOGLE_BOOKS_API_KEY').trim(),
  );
}

@riverpod
class HomeSearchQuery extends _$HomeSearchQuery {
  @override
  String build() => '';

  void setQuery(String value) {
    state = value.trim();
  }
}

@riverpod
class HomeViewMode extends _$HomeViewMode {
  @override
  HomeBooksViewMode build() => HomeBooksViewMode.grid;

  void setMode(HomeBooksViewMode mode) {
    state = mode;
  }
}

@riverpod
Future<List<HomeBook>> homeSearchResults(Ref ref) async {
  final String query = ref.watch(homeSearchQueryProvider);
  if (query.isEmpty) {
    return <HomeBook>[];
  }

  final HomeRepository repo = ref.watch(homeRepositoryProvider);
  return repo.searchBooks(query);
}

@riverpod
Future<List<HomeBook>> homeTrendingResults(Ref ref) async {
  final HomeRepository repo = ref.watch(homeRepositoryProvider);
  return repo.fetchTrendingBooks();
}

@riverpod
Future<HomeBookDetails> homeBookDetails(Ref ref, String bookId) async {
  final String normalizedBookId = bookId.trim();
  if (normalizedBookId.isEmpty) {
    throw const FormatException('Book id cannot be empty.');
  }

  final HomeRepository repo = ref.watch(homeRepositoryProvider);
  return repo.fetchBookDetails(normalizedBookId);
}

@riverpod
Future<ShelfStatus?> homeBookStatus(Ref ref, String bookId) async {
  final String normalizedBookId = bookId.trim();
  if (normalizedBookId.isEmpty) {
    return null;
  }

  final AuthSessionState authState = await ref.watch(
    authSessionProvider.future,
  );
  if (authState != AuthSessionState.authenticated) {
    return null;
  }

  final User? user = FirebaseAuth.instance.currentUser;
  final String? userId = user?.uid;
  if (userId == null || userId.isEmpty) {
    return null;
  }

  final ShelvesRepository shelvesRepo = ref.watch(shelvesRepositoryProvider);
  final Map<String, ShelfStatus> statuses = await shelvesRepo
      .fetchBookStatusesForUser(userId, <String>[normalizedBookId]);
  return statuses[normalizedBookId];
}

@riverpod
Future<ShelfBook?> homeShelfBook(Ref ref, String bookId) async {
  final String normalizedBookId = bookId.trim();
  if (normalizedBookId.isEmpty) {
    return null;
  }

  final AuthSessionState authState = await ref.watch(
    authSessionProvider.future,
  );
  if (authState != AuthSessionState.authenticated) {
    return null;
  }

  final User? user = FirebaseAuth.instance.currentUser;
  final String? userId = user?.uid;
  if (userId == null || userId.isEmpty) {
    return null;
  }

  final ShelvesRepository shelvesRepo = ref.watch(shelvesRepositoryProvider);
  return shelvesRepo.fetchShelfBookForUser(
    userId: userId,
    bookId: normalizedBookId,
  );
}

@riverpod
Future<Map<String, ShelfStatus>> homeBookStatuses(Ref ref) async {
  final AuthSessionState authState = await ref.watch(
    authSessionProvider.future,
  );
  if (authState != AuthSessionState.authenticated) {
    return <String, ShelfStatus>{};
  }

  final User? user = FirebaseAuth.instance.currentUser;
  final String? userId = user?.uid;
  if (userId == null || userId.isEmpty) {
    return <String, ShelfStatus>{};
  }

  final String query = ref.watch(homeSearchQueryProvider);
  final List<HomeBook> books = query.isEmpty
      ? await ref.watch(homeTrendingResultsProvider.future)
      : await ref.watch(homeSearchResultsProvider.future);

  if (books.isEmpty) {
    return <String, ShelfStatus>{};
  }

  final ShelvesRepository shelvesRepo = ref.watch(shelvesRepositoryProvider);
  return shelvesRepo.fetchBookStatusesForUser(
    userId,
    books.map((HomeBook book) => book.id).toList(growable: false),
  );
}

@riverpod
class HomeShelfActionController extends _$HomeShelfActionController {
  @override
  Future<void> build() async {}

  Future<void> setBookStatus({
    required HomeBook book,
    required ShelfStatus status,
  }) async {
    if (!ref.mounted) {
      return;
    }

    state = const AsyncLoading<void>();

    try {
      final AuthSessionState authState = await ref.read(
        authSessionProvider.future,
      );
      if (authState != AuthSessionState.authenticated) {
        throw Exception('Sign in is required to manage shelves.');
      }

      final User? user = FirebaseAuth.instance.currentUser;
      final String? userId = user?.uid;
      if (userId == null || userId.isEmpty) {
        throw Exception('Could not resolve authenticated user.');
      }

      final ShelvesRepository shelvesRepo = ref.read(shelvesRepositoryProvider);
      await shelvesRepo.upsertBookStatusForUser(
        userId: userId,
        book: ShelfBookSeed(
          bookId: book.id,
          title: book.title,
          authors: book.authors,
          thumbnailUrl: book.thumbnailUrl,
        ),
        status: status,
      );

      if (!ref.mounted) {
        return;
      }

      ref.invalidate(homeBookStatusesProvider);
      ref.invalidate(homeBookStatusProvider(book.id));
      ref.invalidate(homeShelfBookProvider(book.id));
      ref.invalidate(shelvesByStatusProvider);
      state = const AsyncData<void>(null);
    } catch (error, stackTrace) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncError<void>(error, stackTrace);
      rethrow;
    }
  }
}

@riverpod
class HomeReadingProgressController extends _$HomeReadingProgressController {
  @override
  Future<void> build() async {}

  Future<ShelfStatus> updateProgress({
    required HomeBookDetails details,
    required int currentPercent,
  }) async {
    if (!ref.mounted) {
      return ShelfStatus.reading;
    }

    state = const AsyncLoading<void>();

    try {
      final AuthSessionState authState = await ref.read(
        authSessionProvider.future,
      );
      if (authState != AuthSessionState.authenticated) {
        throw Exception('Sign in is required to update reading progress.');
      }

      final User? user = FirebaseAuth.instance.currentUser;
      final String? userId = user?.uid;
      if (userId == null || userId.isEmpty) {
        throw Exception('Could not resolve authenticated user.');
      }

      int normalizedPercent = currentPercent.clamp(0, 100);

      ShelfStatus targetStatus = ShelfStatus.reading;
      if (normalizedPercent >= 100) {
        targetStatus = ShelfStatus.completed;
        normalizedPercent = 100;
      }

      final ShelvesRepository shelvesRepo = ref.read(shelvesRepositoryProvider);
      await shelvesRepo.upsertReadingProgressForUser(
        userId: userId,
        book: ShelfBookSeed(
          bookId: details.id,
          title: details.title,
          authors: details.authors,
          thumbnailUrl: details.thumbnailUrl,
        ),
        status: targetStatus,
        currentPercent: normalizedPercent,
      );

      if (!ref.mounted) {
        return targetStatus;
      }

      ref.invalidate(homeBookStatusProvider(details.id));
      ref.invalidate(homeBookStatusesProvider);
      ref.invalidate(homeShelfBookProvider(details.id));
      ref.invalidate(shelvesByStatusProvider);
      state = const AsyncData<void>(null);
      return targetStatus;
    } catch (error, stackTrace) {
      if (ref.mounted) {
        state = AsyncError<void>(error, stackTrace);
      }
      rethrow;
    }
  }
}
