import 'package:read_radius/features/shelves/domain/shelf_status.dart';

class ShelfBook {
  const ShelfBook({
    required this.bookId,
    required this.title,
    required this.authors,
    required this.status,
    this.thumbnailUrl,
    this.updatedAt,
    this.currentPercent,
    this.progressUpdatedAt,
  });

  final String bookId;
  final String title;
  final List<String> authors;
  final ShelfStatus status;
  final String? thumbnailUrl;
  final DateTime? updatedAt;
  final int? currentPercent;
  final DateTime? progressUpdatedAt;
}
