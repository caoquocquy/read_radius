import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';

typedef ShelvesByStatus = Map<ShelfStatus, List<ShelfBook>>;

class ShelfBookSeed {
  const ShelfBookSeed({
    required this.bookId,
    required this.title,
    required this.authors,
    this.thumbnailUrl,
  });

  final String bookId;
  final String title;
  final List<String> authors;
  final String? thumbnailUrl;
}

abstract class ShelvesRepository {
  Future<ShelvesByStatus> fetchShelvesForUser(String userId);
  Future<Map<String, ShelfStatus>> fetchBookStatusesForUser(
    String userId,
    List<String> bookIds,
  );
  Future<void> upsertBookStatusForUser({
    required String userId,
    required ShelfBookSeed book,
    required ShelfStatus status,
  });
}

ShelvesByStatus emptyShelvesByStatus() {
  return <ShelfStatus, List<ShelfBook>>{
    ShelfStatus.wantToRead: <ShelfBook>[],
    ShelfStatus.reading: <ShelfBook>[],
    ShelfStatus.completed: <ShelfBook>[],
  };
}
