class WallBookDetails {
  const WallBookDetails({
    required this.id,
    required this.title,
    required this.authors,
    this.thumbnailUrl,
    this.description,
    this.pageCount,
    this.publishedDate,
    this.categories = const <String>[],
    this.publisher,
    this.previewLink,
  });

  final String id;
  final String title;
  final List<String> authors;
  final String? thumbnailUrl;
  final String? description;
  final int? pageCount;
  final String? publishedDate;
  final List<String> categories;
  final String? publisher;
  final String? previewLink;
}
