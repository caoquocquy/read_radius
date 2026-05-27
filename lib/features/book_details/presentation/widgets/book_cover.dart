import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookCover extends StatelessWidget {
  const BookCover({required this.url, super.key});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final String? normalized = url?.trim();
    if (normalized == null || normalized.isEmpty) {
      return const _CoverPlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: normalized,
        width: 112,
        height: 164,
        fit: BoxFit.cover,
        placeholder: (BuildContext context, String _) {
          return const _CoverPlaceholder();
        },
        errorWidget: (BuildContext context, String failedUrl, Object error) {
          return const _CoverPlaceholder();
        },
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 164,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.menu_book_rounded,
        size: 36,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
