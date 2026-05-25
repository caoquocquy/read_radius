import 'package:book_radius/features/wall/data/google_books_wall_repository.dart';
import 'package:book_radius/features/wall/domain/wall_book.dart';
import 'package:book_radius/features/wall/domain/wall_repository.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wall_providers.g.dart';

@riverpod
http.Client wallHttpClient(Ref ref) {
  final http.Client client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@riverpod
WallRepository wallRepository(Ref ref) {
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
Future<List<WallBook>> wallSearchResults(Ref ref) async {
  final String query = ref.watch(wallSearchQueryProvider);
  if (query.isEmpty) {
    return <WallBook>[];
  }

  final WallRepository repo = ref.watch(wallRepositoryProvider);
  return repo.searchBooks(query);
}
