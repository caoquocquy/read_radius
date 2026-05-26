import 'package:read_radius/features/home/domain/wall_book.dart';
import 'package:read_radius/features/home/providers/wall_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WallBooksCollection extends StatelessWidget {
  const WallBooksCollection({
    required this.books,
    required this.viewMode,
    required this.actionLabelBuilder,
    required this.onBookTap,
    required this.onActionPressed,
    required this.isActionLoading,
    this.enableThumbnail = true,
    super.key,
  });

  final List<WallBook> books;
  final WallBooksViewMode viewMode;
  final String Function(WallBook book) actionLabelBuilder;
  final ValueChanged<WallBook> onBookTap;
  final ValueChanged<WallBook> onActionPressed;
  final bool Function(WallBook book) isActionLoading;
  final bool enableThumbnail;

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
              onTap: () {
                onBookTap(book);
              },
              leading: _BookThumbnail(
                url: book.thumbnailUrl,
                enabled: enableThumbnail,
              ),
              title: Text(book.title),
              subtitle: Text(subtitle),
              trailing: FilledButton.tonal(
                onPressed: isActionLoading(book)
                    ? null
                    : () {
                        onActionPressed(book);
                      },
                child: isActionLoading(book)
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(actionLabelBuilder(book)),
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
            childAspectRatio: 0.7,
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
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          onBookTap(book);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 72,
                                height: 104,
                                child: _BookThumbnail(
                                  url: book.thumbnailUrl,
                                  enabled: enableThumbnail,
                                ),
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
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.tonal(
                      onPressed: isActionLoading(book)
                          ? null
                          : () {
                              onActionPressed(book);
                            },
                      child: isActionLoading(book)
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(actionLabelBuilder(book)),
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
  const _BookThumbnail({required this.url, required this.enabled});

  final String? url;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled || url == null || url!.isEmpty) {
      return const _BookThumbnailPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: CachedNetworkImage(
        imageUrl: url!,
        width: 44,
        height: 64,
        fit: BoxFit.cover,
        memCacheWidth: 176,
        maxWidthDiskCache: 176,
        fadeInDuration: Duration.zero,
        placeholder: (BuildContext context, String _) {
          return const _BookThumbnailPlaceholder();
        },
        errorWidget: (BuildContext context, String failedUrl, Object error) {
          debugPrint('Thumbnail load failed for $failedUrl: $error');
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
