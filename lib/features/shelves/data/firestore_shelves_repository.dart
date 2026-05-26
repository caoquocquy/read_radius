import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/shelves/domain/shelves_repository.dart';

class FirestoreShelvesRepository implements ShelvesRepository {
  FirestoreShelvesRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const int _whereInChunkSize = 10;

  @override
  Future<ShelvesByStatus> fetchShelvesForUser(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> userBooksSnapshot =
        await _firestore
            .collection('userBooks')
            .where('userId', isEqualTo: userId)
            .get();

    final ShelvesByStatus grouped = emptyShelvesByStatus();
    if (userBooksSnapshot.docs.isEmpty) {
      return grouped;
    }

    final List<_UserBookRecord> records = userBooksSnapshot.docs
        .map(_toUserBookRecord)
        .whereType<_UserBookRecord>()
        .toList(growable: false);

    final Map<String, Map<String, dynamic>> booksById = await _fetchBooksByIds(
      records.map((record) => record.bookId).toSet().toList(growable: false),
    );

    for (final _UserBookRecord record in records) {
      final Map<String, dynamic>? bookData = booksById[record.bookId];
      grouped[record.status]!.add(_toShelfBook(record, bookData));
    }

    for (final ShelfStatus status in ShelfStatus.values) {
      grouped[status]!.sort((ShelfBook a, ShelfBook b) {
        final DateTime? bTime = b.updatedAt;
        final DateTime? aTime = a.updatedAt;
        if (aTime != null && bTime != null) {
          return bTime.compareTo(aTime);
        }
        if (bTime != null) {
          return 1;
        }
        if (aTime != null) {
          return -1;
        }
        return a.title.compareTo(b.title);
      });
    }

    return grouped;
  }

  @override
  Future<Map<String, ShelfStatus>> fetchBookStatusesForUser(
    String userId,
    List<String> bookIds,
  ) async {
    if (bookIds.isEmpty) {
      return <String, ShelfStatus>{};
    }

    final Map<String, ShelfStatus> statuses = <String, ShelfStatus>{};

    for (final List<String> chunk in _chunk(bookIds, _whereInChunkSize)) {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('userBooks')
          .where('userId', isEqualTo: userId)
          .where('bookId', whereIn: chunk)
          .get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        final Map<String, dynamic> data = doc.data();
        final String? bookId = (data['bookId'] as String?)?.trim();
        final ShelfStatus? status = shelfStatusFromStorage(
          data['status'] as String?,
        );
        if (bookId == null || bookId.isEmpty || status == null) {
          continue;
        }
        statuses[bookId] = status;
      }
    }

    return statuses;
  }

  @override
  Future<void> upsertBookStatusForUser({
    required String userId,
    required ShelfBookSeed book,
    required ShelfStatus status,
  }) async {
    final String bookId = book.bookId.trim();
    if (bookId.isEmpty) {
      throw const FormatException('Book id cannot be empty.');
    }

    await _ensureBookExists(book);

    final String docId = '${userId}_$bookId';
    final DocumentReference<Map<String, dynamic>> userBookRef = _firestore
        .collection('userBooks')
        .doc(docId);

    final DocumentSnapshot<Map<String, dynamic>> existing = await userBookRef
        .get();

    await userBookRef.set(<String, dynamic>{
      'userId': userId,
      'bookId': bookId,
      'status': status.storageValue,
      'updatedAt': FieldValue.serverTimestamp(),
      if (!existing.exists) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  _UserBookRecord? _toUserBookRecord(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final Map<String, dynamic>? data = doc.data();
    if (data == null) {
      return null;
    }

    final String? bookId = (data['bookId'] as String?)?.trim();
    final ShelfStatus? status = shelfStatusFromStorage(
      data['status'] as String?,
    );

    if (bookId == null || bookId.isEmpty || status == null) {
      return null;
    }

    final Timestamp? updatedTimestamp = data['updatedAt'] as Timestamp?;

    return _UserBookRecord(
      bookId: bookId,
      status: status,
      updatedAt: updatedTimestamp?.toDate(),
    );
  }

  ShelfBook _toShelfBook(
    _UserBookRecord record,
    Map<String, dynamic>? bookData,
  ) {
    final String title =
        ((bookData?['title'] as String?)?.trim().isNotEmpty ?? false)
        ? (bookData!['title'] as String).trim()
        : record.bookId;

    final List<String> authors =
        (bookData?['authors'] as List<dynamic>? ?? <dynamic>[])
            .whereType<String>()
            .map((String name) => name.trim())
            .where((String name) => name.isNotEmpty)
            .toList(growable: false);

    final String? thumbnailUrl = _extractThumbnail(bookData);

    return ShelfBook(
      bookId: record.bookId,
      title: title,
      authors: authors,
      status: record.status,
      thumbnailUrl: thumbnailUrl,
      updatedAt: record.updatedAt,
    );
  }

  String? _extractThumbnail(Map<String, dynamic>? bookData) {
    if (bookData == null) {
      return null;
    }

    final String? direct = (bookData['thumbnailUrl'] as String?)?.trim();
    if (direct != null && direct.isNotEmpty) {
      return direct;
    }

    final Map<String, dynamic>? imageLinks =
        bookData['imageLinks'] as Map<String, dynamic>?;
    final String? nested =
        (imageLinks?['thumbnail'] as String?)?.trim() ??
        (imageLinks?['smallThumbnail'] as String?)?.trim();
    if (nested == null || nested.isEmpty) {
      return null;
    }

    final Uri? uri = Uri.tryParse(nested);
    if (uri == null) {
      return nested.replaceFirst('http://', 'https://');
    }

    return uri.replace(scheme: 'https').toString();
  }

  Future<Map<String, Map<String, dynamic>>> _fetchBooksByIds(
    List<String> bookIds,
  ) async {
    final Map<String, Map<String, dynamic>> result =
        <String, Map<String, dynamic>>{};

    if (bookIds.isEmpty) {
      return result;
    }

    for (final List<String> chunk in _chunk(bookIds, _whereInChunkSize)) {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('books')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
          in snapshot.docs) {
        result[doc.id] = doc.data();
      }
    }

    return result;
  }

  Iterable<List<String>> _chunk(List<String> values, int size) sync* {
    for (int index = 0; index < values.length; index += size) {
      final int end = (index + size < values.length)
          ? index + size
          : values.length;
      yield values.sublist(index, end);
    }
  }

  Future<void> _ensureBookExists(ShelfBookSeed book) async {
    final String bookId = book.bookId.trim();
    final DocumentReference<Map<String, dynamic>> bookRef = _firestore
        .collection('books')
        .doc(bookId);

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await bookRef.get();
    if (snapshot.exists) {
      return;
    }

    await bookRef.set(<String, dynamic>{
      'bookId': bookId,
      'title': book.title.trim().isEmpty ? bookId : book.title.trim(),
      'authors': book.authors,
      if (book.thumbnailUrl != null && book.thumbnailUrl!.trim().isNotEmpty)
        'thumbnailUrl': book.thumbnailUrl!.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

class _UserBookRecord {
  const _UserBookRecord({
    required this.bookId,
    required this.status,
    required this.updatedAt,
  });

  final String bookId;
  final ShelfStatus status;
  final DateTime? updatedAt;
}
