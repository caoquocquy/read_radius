import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/shelves/domain/shelves_repository.dart';
import 'package:read_radius/features/shelves/providers/shelves_providers.dart';
import 'package:read_radius/features/wall/data/example_wall_repository.dart';
import 'package:read_radius/features/wall/data/google_books_wall_repository.dart';
import 'package:read_radius/features/wall/domain/wall_book.dart';
import 'package:read_radius/features/wall/domain/wall_repository.dart';
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
