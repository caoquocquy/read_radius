import 'package:firebase_auth/firebase_auth.dart';
import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/home/data/example_home_repository.dart';
import 'package:read_radius/features/home/data/google_books_home_repository.dart';
import 'package:read_radius/features/home/domain/home_book.dart';
import 'package:read_radius/features/home/domain/home_repository.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/shelves/domain/shelves_repository.dart';
import 'package:read_radius/features/shelves/providers/shelves_providers.dart';
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
class HomeShelfActionController extends _$HomeShelfActionController {
  @override
  Future<void> build() async {}

  Future<void> setBookStatus({
    required HomeBook book,
    required ShelfStatus status,
  }) async {
    final AuthSessionState authState = await ref.watch(
      authSessionProvider.future,
    );
    if (authState != AuthSessionState.authenticated) {
      throw Exception('You must be signed in to save books to your shelves.');
    }

    final User? user = FirebaseAuth.instance.currentUser;
    final String? userId = user?.uid;
    if (userId == null || userId.isEmpty) {
      throw Exception('User not found.');
    }

    final ShelvesRepository shelvesRepo = ref.watch(shelvesRepositoryProvider);
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

    ref.invalidate(homeBookStatusesProvider);
    ref.invalidate(shelvesByStatusProvider);
  }
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
