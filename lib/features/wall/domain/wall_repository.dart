import 'package:read_radius/features/wall/domain/wall_book.dart';

abstract class WallRepository {
  Future<List<WallBook>> searchBooks(String query);
  Future<List<WallBook>> fetchTrendingBooks();
}
