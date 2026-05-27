import 'package:read_radius/features/home/domain/home_book.dart';
import 'package:read_radius/features/home/providers/home_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeBooksCollection extends StatelessWidget {
  const HomeBooksCollection({
    required this.books,
    required this.viewMode,
    required this.actionLabelBuilder,
    required this.onBookTap,
    required this.onActionPressed,
    required this.isActionLoading,
    this.enableThumbnail = true,
    this.progressPercentBuilder,
    super.key,
  });

  final List<HomeBook> books;
  final HomeBooksViewMode viewMode;
  final String Function(HomeBook book) actionLabelBuilder;
  final ValueChanged<HomeBook> onBookTap;
  final ValueChanged<HomeBook> onActionPressed;
  final bool Function(HomeBook book) isActionLoading;
  final bool enableThumbnail;
  final int? Function(HomeBook book)? progressPercentBuilder;

  @override
  Widget build(BuildContext context) {
    if (viewMode == HomeBooksViewMode.list) {
      return ListView.separated(
        key: const Key('home-list-view'),
        itemCount: books.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 8),
        itemBuilder: (BuildContext context, int index) {
          final HomeBook book = books[index];
          final String subtitle = book.authors.isEmpty
              ? 'Unknown author'
              : book.authors.join(', ');

          final int? progressPercent = progressPercentBuilder != null
              ? progressPercentBuilder!(book)
              : null;

          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
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
                if (progressPercent != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 72,
                      right: 12,
                      bottom: 12,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progressPercent / 100.0,
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$progressPercent%',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
              ],
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
          key: const Key('home-grid-view'),
          itemCount: books.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (BuildContext context, int index) {
            final HomeBook book = books[index];
            final String subtitle = book.authors.isEmpty
                ? 'Unknown author'
                : book.authors.join(', ');

            final int? progressPercent = progressPercentBuilder != null
                ? progressPercentBuilder!(book)
                : null;

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
                    if (progressPercent != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progressPercent / 100.0,
                                minHeight: 6,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$progressPercent%',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
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
