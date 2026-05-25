import 'dart:convert';

import 'package:read_radius/features/wall/domain/wall_book.dart';
import 'package:read_radius/features/wall/domain/wall_repository.dart';
import 'package:http/http.dart' as http;

class GoogleBooksWallRepository implements WallRepository {
  GoogleBooksWallRepository(this._httpClient, {required this.apiKey});

  final http.Client _httpClient;
  final String apiKey;

  static final Uri _baseUri = Uri.parse(
    'https://www.googleapis.com/books/v1/volumes',
  );
  static const String _maxResults = '10';

  @override
  Future<List<WallBook>> searchBooks(String query) async {
    final String normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return <WallBook>[];
    }

    return _fetchBooks(<String, String>{
      'q': normalizedQuery,
      'maxResults': _maxResults,
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
      'maxResults': _maxResults,
      'printType': 'books',
    });
  }

  Future<List<WallBook>> _fetchBooks(
    Map<String, String> queryParameters,
  ) async {
    final http.Response response = await _requestBooks(
      queryParameters,
      includeApiKey: apiKey.isNotEmpty,
    );

    if (response.statusCode == 400 && apiKey.isNotEmpty) {
      final String loweredBody = response.body.toLowerCase();
      final bool keyIssue =
          loweredBody.contains('api_key_invalid') ||
          loweredBody.contains('keyinvalid') ||
          loweredBody.contains('apikey') ||
          loweredBody.contains('api key');
      if (keyIssue) {
        final http.Response fallback = await _requestBooks(
          queryParameters,
          includeApiKey: false,
        );
        if (fallback.statusCode >= 200 && fallback.statusCode < 300) {
          return _decodeBooks(fallback.body);
        }

        throw Exception(_buildHttpErrorMessage(fallback));
      }
    }

    if (response.statusCode == 429 && apiKey.isNotEmpty) {
      final http.Response fallback = await _requestBooks(
        queryParameters,
        includeApiKey: false,
      );
      if (fallback.statusCode >= 200 && fallback.statusCode < 300) {
        return _decodeBooks(fallback.body);
      }
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_buildHttpErrorMessage(response));
    }

    return _decodeBooks(response.body);
  }

  Future<http.Response> _requestBooks(
    Map<String, String> queryParameters, {
    required bool includeApiKey,
  }) {
    final Uri uri = _baseUri.replace(
      queryParameters: <String, String>{
        ...queryParameters,
        if (includeApiKey) 'key': apiKey,
      },
    );

    return _httpClient.get(uri);
  }

  List<WallBook> _decodeBooks(String responseBody) {
    final Object? decoded = jsonDecode(responseBody);
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

  String _buildHttpErrorMessage(http.Response response) {
    if (response.statusCode == 429) {
      return 'Google Books quota exceeded. Add GOOGLE_BOOKS_API_KEY via --dart-define or increase API quota.';
    }

    final String? apiMessage = _extractApiErrorMessage(response.body);
    if (apiMessage != null && apiMessage.isNotEmpty) {
      return 'Google Books request failed (${response.statusCode}): $apiMessage';
    }

    return 'Google Books request failed (${response.statusCode}).';
  }

  String? _extractApiErrorMessage(String responseBody) {
    try {
      final Object? decoded = jsonDecode(responseBody);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final Object? error = decoded['error'];
      if (error is! Map<String, dynamic>) {
        return null;
      }

      final Object? message = error['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    } catch (_) {
      // Ignore parse failures and fall back to generic HTTP message.
    }

    return null;
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
        (imageLinks?['smallThumbnail'] as String?) ??
        (imageLinks?['thumbnail'] as String?);

    return WallBook(
      id: id,
      title: title,
      authors: authors,
      thumbnailUrl: _normalizeThumbnailUrl(thumbnailUrl),
    );
  }

  String? _normalizeThumbnailUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) {
      return null;
    }

    final Uri? uri = Uri.tryParse(rawUrl);
    if (uri == null) {
      return rawUrl.replaceFirst('http://', 'https://');
    }

    // Keep the original query/path intact and only force HTTPS.
    // Rebuilding query parameters can drop/alter provider-specific values.
    return uri.replace(scheme: 'https').toString();
  }
}
