import 'package:read_radius/features/wall/domain/wall_book.dart';
import 'package:read_radius/features/wall/providers/wall_providers.dart';
import 'package:flutter/material.dart';

class WallBooksCollection extends StatelessWidget {
  const WallBooksCollection({
    required this.books,
    required this.viewMode,
    required this.onAddPressed,
    super.key,
  });

  final List<WallBook> books;
  final WallBooksViewMode viewMode;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    if (viewMode == WallBooksViewMode.list) {
      return ListView.separated(
        key: const Key('wall-list-view'),
        itemCount: books.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final WallBook book = books[index];
          final String subtitle = book.authors.isEmpty
              ? 'Unknown author'
              : book.authors.join(', ');

          return Card(
            child: ListTile(
              leading: _BookThumbnail(url: book.thumbnailUrl),
              title: Text(book.title),
              subtitle: Text(subtitle),
              trailing: FilledButton.tonal(
                onPressed: onAddPressed,
                child: const Text('Add'),
              ),
            ),
          );
        },
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = width >= 900
            ? 5
            : width >= 700
            ? 4
            : width >= 500
            ? 3
            : 2;

        return GridView.builder(
          key: const Key('wall-grid-view'),
          itemCount: books.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.54,
          ),
          itemBuilder: (BuildContext context, int index) {
            final WallBook book = books[index];
            final String subtitle = book.authors.isEmpty
                ? 'Unknown author'
                : book.authors.join(', ');

            return Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 72,
                        height: 104,
                        child: _BookThumbnail(url: book.thumbnailUrl),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    FilledButton.tonal(
                      onPressed: onAddPressed,
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _BookThumbnail extends StatelessWidget {
  const _BookThumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return const _BookThumbnailPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        url!,
        width: 44,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (BuildContext context, Object error, StackTrace? _) {
          return const _BookThumbnailPlaceholder();
        },
      ),
    );
  }
}

class _BookThumbnailPlaceholder extends StatelessWidget {
  const _BookThumbnailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 64,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: 20,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
