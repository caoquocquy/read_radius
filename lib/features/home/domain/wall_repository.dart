import 'package:read_radius/features/home/domain/wall_book.dart';
import 'package:read_radius/features/home/domain/wall_book_details.dart';

abstract class WallRepository {
  Future<List<WallBook>> searchBooks(String query);
  Future<List<WallBook>> fetchTrendingBooks();
  Future<WallBookDetails> fetchBookDetails(String bookId);
}
