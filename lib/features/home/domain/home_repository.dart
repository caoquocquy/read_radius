import 'package:read_radius/features/home/domain/home_book.dart';
import 'package:read_radius/features/home/domain/home_book_details.dart';

abstract class HomeRepository {
  Future<List<HomeBook>> searchBooks(String query);
  Future<List<HomeBook>> fetchTrendingBooks();
  Future<HomeBookDetails> fetchBookDetails(String bookId);
}
