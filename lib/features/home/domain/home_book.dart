class HomeBook {
  const HomeBook({
    required this.id,
    required this.title,
    required this.authors,
    this.thumbnailUrl,
  });

  final String id;
  final String title;
  final List<String> authors;
  final String? thumbnailUrl;
}
