import 'dart:convert';

import 'package:book_radius/features/wall/domain/wall_book.dart';
import 'package:book_radius/features/wall/domain/wall_repository.dart';
import 'package:http/http.dart' as http;

class GoogleBooksWallRepository implements WallRepository {
  GoogleBooksWallRepository(this._httpClient, {required this.apiKey});

  final http.Client _httpClient;
  final String apiKey;

  static final Uri _baseUri = Uri.parse(
    'https://www.googleapis.com/books/v1/volumes',
  );

  @override
  Future<List<WallBook>> searchBooks(String query) async {
    final String normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return <WallBook>[];
    }

    return _fetchBooks(<String, String>{
      'q': normalizedQuery,
      'maxResults': '20',
      'printType': 'books',
    });
  }

  @override
  Future<List<WallBook>> fetchTrendingBooks() {
    return _fetchBooks(<String, String>{
      // Google Books has no dedicated trending endpoint.
      // Use a broad subject query for a dynamic, popular-feeling feed.
      'q': 'subject:fiction',
      'orderBy': 'newest',
      'maxResults': '20',
      'printType': 'books',
    });
  }

  Future<List<WallBook>> _fetchBooks(
    Map<String, String> queryParameters,
  ) async {
    final Uri uri = _baseUri.replace(
      queryParameters: <String, String>{
        ...queryParameters,
        if (apiKey.isNotEmpty) 'key': apiKey,
      },
    );

    final http.Response response = await _httpClient.get(uri);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      if (response.statusCode == 429) {
        throw Exception(
          'Google Books quota exceeded. Add GOOGLE_BOOKS_API_KEY via --dart-define or increase API quota.',
        );
      }

      throw Exception('Google Books request failed (${response.statusCode}).');
    }

    final Object? decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid response format from Google Books API.',
      );
    }

    final List<dynamic> items =
        (decoded['items'] as List<dynamic>? ?? <dynamic>[]);
    return items
        .whereType<Map<String, dynamic>>()
        .map(_mapBook)
        .whereType<WallBook>()
        .toList(growable: false);
  }

  WallBook? _mapBook(Map<String, dynamic> json) {
    final String? id = json['id'] as String?;
    final Map<String, dynamic>? volumeInfo =
        json['volumeInfo'] as Map<String, dynamic>?;
    final String? title = volumeInfo?['title'] as String?;

    if (id == null || id.isEmpty || title == null || title.isEmpty) {
      return null;
    }

    final List<String> authors =
        (volumeInfo?['authors'] as List<dynamic>? ?? <dynamic>[])
            .whereType<String>()
            .where((String name) => name.trim().isNotEmpty)
            .toList(growable: false);

    final Map<String, dynamic>? imageLinks =
        volumeInfo?['imageLinks'] as Map<String, dynamic>?;
    final String? thumbnailUrl =
        (imageLinks?['thumbnail'] as String?) ??
        (imageLinks?['smallThumbnail'] as String?);

    return WallBook(
      id: id,
      title: title,
      authors: authors,
      thumbnailUrl: thumbnailUrl,
    );
  }
}
