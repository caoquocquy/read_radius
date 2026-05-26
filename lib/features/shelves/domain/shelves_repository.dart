import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';

typedef ShelvesByStatus = Map<ShelfStatus, List<ShelfBook>>;

abstract class ShelvesRepository {
  Future<ShelvesByStatus> fetchShelvesForUser(String userId);
}

ShelvesByStatus emptyShelvesByStatus() {
  return <ShelfStatus, List<ShelfBook>>{
    ShelfStatus.wantToRead: <ShelfBook>[],
    ShelfStatus.reading: <ShelfBook>[],
    ShelfStatus.completed: <ShelfBook>[],
  };
}
