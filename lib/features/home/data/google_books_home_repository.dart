import 'dart:convert';

import 'package:read_radius/features/home/domain/home_book.dart';
import 'package:read_radius/features/home/domain/home_book_details.dart';
import 'package:read_radius/features/home/domain/home_repository.dart';
import 'package:http/http.dart' as http;

class GoogleBooksHomeRepository implements HomeRepository {
  GoogleBooksHomeRepository(this._httpClient, {required this.apiKey});

  final http.Client _httpClient;
  final String apiKey;

  static final Uri _baseUri = Uri.parse(
    'https://www.googleapis.com/books/v1/volumes',
  );
  static const String _maxResults = '10';

  @override
  Future<List<HomeBook>> searchBooks(String query) async {
    final String normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) {
      return <HomeBook>[];
    }

    return _fetchBooks(<String, String>{
      'q': normalizedQuery,
      'maxResults': _maxResults,
      'printType': 'books',
    });
  }

  @override
  Future<List<HomeBook>> fetchTrendingBooks() {
    return _fetchBooks(<String, String>{
      'q': 'subject:fiction',
      'orderBy': 'newest',
      'maxResults': _maxResults,
      'printType': 'books',
    });
  }

  @override
  Future<HomeBookDetails> fetchBookDetails(String bookId) async {
    final String normalizedBookId = bookId.trim();
    if (normalizedBookId.isEmpty) {
      throw const FormatException('Book id cannot be empty.');
    }

    final http.Response response = await _requestBookById(
      normalizedBookId,
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
        final http.Response fallback = await _requestBookById(
          normalizedBookId,
          includeApiKey: false,
        );
        if (fallback.statusCode >= 200 && fallback.statusCode < 300) {
          return _decodeBookDetails(fallback.body);
        }

        throw Exception(_buildHttpErrorMessage(fallback));
      }
    }

    if (response.statusCode == 429 && apiKey.isNotEmpty) {
      final http.Response fallback = await _requestBookById(
        normalizedBookId,
        includeApiKey: false,
      );
      if (fallback.statusCode >= 200 && fallback.statusCode < 300) {
        return _decodeBookDetails(fallback.body);
      }
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(_buildHttpErrorMessage(response));
    }

    return _decodeBookDetails(response.body);
  }

  Future<List<HomeBook>> _fetchBooks(
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

  Future<http.Response> _requestBookById(
    String bookId, {
    required bool includeApiKey,
  }) {
    final Uri uri = _baseUri
        .replace(path: '${_baseUri.path}/$bookId')
        .replace(
          queryParameters: <String, String>{if (includeApiKey) 'key': apiKey},
        );

    return _httpClient.get(uri);
  }

  List<HomeBook> _decodeBooks(String responseBody) {
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
        .whereType<HomeBook>()
        .toList(growable: false);
  }

  HomeBookDetails _decodeBookDetails(String responseBody) {
    final Object? decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid response format from Google Books API.',
      );
    }

    return _mapBookDetails(decoded);
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

  HomeBook? _mapBook(Map<String, dynamic> json) {
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

    return HomeBook(
      id: id,
      title: title,
      authors: authors,
      thumbnailUrl: _normalizeThumbnailUrl(thumbnailUrl),
    );
  }

  HomeBookDetails _mapBookDetails(Map<String, dynamic> json) {
    final String? id = json['id'] as String?;
    final Map<String, dynamic>? volumeInfo =
        json['volumeInfo'] as Map<String, dynamic>?;
    final String? title = (volumeInfo?['title'] as String?)?.trim();
    final String normalizedId = (id ?? '').trim();
    if (normalizedId.isEmpty || title == null || title.isEmpty) {
      throw const FormatException(
        'Google Books details payload is missing id/title.',
      );
    }

    final List<String> authors =
        (volumeInfo?['authors'] as List<dynamic>? ?? <dynamic>[])
            .whereType<String>()
            .map((String name) => name.trim())
            .where((String name) => name.isNotEmpty)
            .toList(growable: false);

    final List<String> categories =
        (volumeInfo?['categories'] as List<dynamic>? ?? <dynamic>[])
            .whereType<String>()
            .map((String category) => category.trim())
            .where((String category) => category.isNotEmpty)
            .toList(growable: false);

    final Map<String, dynamic>? imageLinks =
        volumeInfo?['imageLinks'] as Map<String, dynamic>?;
    final String? thumbnailUrl =
        (imageLinks?['smallThumbnail'] as String?) ??
        (imageLinks?['thumbnail'] as String?);

    final Object? pageCountRaw = volumeInfo?['pageCount'];
    final int? pageCount = pageCountRaw is int ? pageCountRaw : null;

    final String? publisher = (volumeInfo?['publisher'] as String?)?.trim();
    final String? publishedDate = (volumeInfo?['publishedDate'] as String?)
        ?.trim();
    final String? description = (volumeInfo?['description'] as String?)?.trim();
    final String? previewLink = (volumeInfo?['previewLink'] as String?)?.trim();

    return HomeBookDetails(
      id: normalizedId,
      title: title,
      authors: authors,
      thumbnailUrl: _normalizeThumbnailUrl(thumbnailUrl),
      description: description == null || description.isEmpty
          ? null
          : description,
      pageCount: pageCount,
      publishedDate: publishedDate == null || publishedDate.isEmpty
          ? null
          : publishedDate,
      categories: categories,
      publisher: publisher == null || publisher.isEmpty ? null : publisher,
      previewLink: _normalizePreviewUrl(previewLink),
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

    return uri.replace(scheme: 'https').toString();
  }

  String? _normalizePreviewUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.isEmpty) {
      return null;
    }

    final Uri? uri = Uri.tryParse(rawUrl);
    if (uri == null) {
      return rawUrl;
    }

    return uri.replace(scheme: 'https').toString();
  }
}
