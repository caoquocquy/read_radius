import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/shelves/domain/shelves_repository.dart';
import 'package:read_radius/features/shelves/providers/shelves_providers.dart';
import 'package:read_radius/features/home/data/example_wall_repository.dart';
import 'package:read_radius/features/home/data/google_books_wall_repository.dart';
import 'package:read_radius/features/home/domain/wall_book.dart';
import 'package:read_radius/features/home/domain/wall_book_details.dart';
import 'package:read_radius/features/home/domain/wall_repository.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wall_providers.g.dart';

enum WallBooksViewMode { grid, list }

const bool enableWallExampleData = true;

@riverpod
class WallLocalBookStatuses extends _$WallLocalBookStatuses {
  @override
  Map<String, ShelfStatus> build() => <String, ShelfStatus>{};

  void setStatus(String bookId, ShelfStatus status) {
    state = <String, ShelfStatus>{...state, bookId: status};
  }
}

@riverpod
http.Client wallHttpClient(Ref ref) {
  final http.Client client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@riverpod
WallRepository wallRepository(Ref ref) {
  if (enableWallExampleData) {
    return ExampleWallRepository();
  }

  return GoogleBooksWallRepository(
    ref.watch(wallHttpClientProvider),
    apiKey: const String.fromEnvironment('GOOGLE_BOOKS_API_KEY').trim(),
  );
}

@riverpod
class WallSearchQuery extends _$WallSearchQuery {
  @override
  String build() => '';

  void setQuery(String value) {
    state = value.trim();
  }
}

@riverpod
class WallViewMode extends _$WallViewMode {
  @override
  WallBooksViewMode build() => WallBooksViewMode.grid;

  void setMode(WallBooksViewMode mode) {
    state = mode;
  }
}

@riverpod
Future<List<WallBook>> wallSearchResults(Ref ref) async {
  final String query = ref.watch(wallSearchQueryProvider);
  if (query.isEmpty) {
    return <WallBook>[];
  }

  final WallRepository repo = ref.watch(wallRepositoryProvider);
  return repo.searchBooks(query);
}

@riverpod
Future<List<WallBook>> wallTrendingResults(Ref ref) async {
  final WallRepository repo = ref.watch(wallRepositoryProvider);
  return repo.fetchTrendingBooks();
}

@riverpod
Future<WallBookDetails> wallBookDetails(Ref ref, String bookId) async {
  final String normalizedBookId = bookId.trim();
  if (normalizedBookId.isEmpty) {
    throw const FormatException('Book id cannot be empty.');
  }

  final WallRepository repo = ref.watch(wallRepositoryProvider);
  return repo.fetchBookDetails(normalizedBookId);
}

@riverpod
Future<ShelfStatus?> wallBookStatus(Ref ref, String bookId) async {
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
Future<ShelfBook?> wallShelfBook(Ref ref, String bookId) async {
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
Future<Map<String, ShelfStatus>> wallBookStatuses(Ref ref) async {
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

  final String query = ref.watch(wallSearchQueryProvider);
  final List<WallBook> books = query.isEmpty
      ? await ref.watch(wallTrendingResultsProvider.future)
      : await ref.watch(wallSearchResultsProvider.future);

  if (books.isEmpty) {
    return <String, ShelfStatus>{};
  }

  final ShelvesRepository shelvesRepo = ref.watch(shelvesRepositoryProvider);
  return shelvesRepo.fetchBookStatusesForUser(
    userId,
    books.map((WallBook book) => book.id).toList(growable: false),
  );
}

@riverpod
class WallShelfActionController extends _$WallShelfActionController {
  @override
  Future<void> build() async {}

  Future<void> setBookStatus({
    required WallBook book,
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

      ref.invalidate(wallBookStatusesProvider);
      ref.invalidate(wallBookStatusProvider(book.id));
      ref.invalidate(wallShelfBookProvider(book.id));
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
class WallReadingProgressController extends _$WallReadingProgressController {
  @override
  Future<void> build() async {}

  Future<ShelfStatus> updateProgress({
    required WallBookDetails details,
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

      ref.invalidate(wallBookStatusProvider(details.id));
      ref.invalidate(wallBookStatusesProvider);
      ref.invalidate(wallShelfBookProvider(details.id));
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
