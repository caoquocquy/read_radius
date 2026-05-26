import 'package:cached_network_image/cached_network_image.dart';
import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:flutter/material.dart';

class ShelvesSection extends StatelessWidget {
  const ShelvesSection({
    required this.title,
    required this.books,
    required this.onBookTap,
    super.key,
  });

  final String title;
  final List<ShelfBook> books;
  final ValueChanged<ShelfBook> onBookTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        if (books.isEmpty)
          const Card(child: ListTile(title: Text('No books yet.')))
        else
          ...books.map((ShelfBook book) {
            final String subtitle = book.authors.isEmpty
                ? 'Unknown author'
                : book.authors.join(', ');

            return Card(
              child: ListTile(
                onTap: () {
                  onBookTap(book);
                },
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                leading: _ShelfBookThumbnail(url: book.thumbnailUrl),
                title: Text(book.title),
                subtitle: Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }),
      ],
    );
  }
}

class _ShelfBookThumbnail extends StatelessWidget {
  const _ShelfBookThumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return const _ShelfThumbnailPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: CachedNetworkImage(
        imageUrl: url!,
        width: 42,
        height: 60,
        fit: BoxFit.cover,
        memCacheWidth: 168,
        maxWidthDiskCache: 168,
        fadeInDuration: Duration.zero,
        placeholder: (BuildContext context, String _) {
          return const _ShelfThumbnailPlaceholder();
        },
        errorWidget: (BuildContext context, String failedUrl, Object error) {
          return const _ShelfThumbnailPlaceholder();
        },
      ),
    );
  }
}

class _ShelfThumbnailPlaceholder extends StatelessWidget {
  const _ShelfThumbnailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: 18,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
