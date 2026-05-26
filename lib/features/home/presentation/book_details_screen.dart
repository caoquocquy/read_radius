import 'dart:async';

import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/home/domain/home_book_details.dart';
import 'package:read_radius/features/home/providers/home_providers.dart';
import 'package:read_radius/features/shelves/providers/shelves_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookDetailsScreen extends ConsumerStatefulWidget {
  const BookDetailsScreen({required this.bookId, super.key});

  static const String routeName = 'book-details-screen';
  static const String routePath = '/books/:bookId';

  final String bookId;

  @override
  ConsumerState<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  bool _isSubmittingProgress = false;

  Future<int?> _pickProgressPercent(BuildContext context, int currentPercent) {
    return showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List<Widget>.generate(10, (int i) {
                final int percent = (i + 1) * 10;
                return FilledButton(
                  onPressed: () => Navigator.of(context).pop(percent),
                  child: Text('$percent%'),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleProgressAction(
    int currentPercent,
    String bookId,
    HomeBookDetails details,
  ) async {
    setState(() {
      _isSubmittingProgress = true;
    });

    try {
      final int? selected = await _pickProgressPercent(context, currentPercent);
      if (selected == null) return;

      final ShelfStatus status = await ref
          .read(homeReadingProgressControllerProvider.notifier)
          .updateProgress(details: details, currentPercent: selected);

      if (!mounted) return;

      ref.invalidate(homeShelfBookProvider(bookId));
      ref.invalidate(homeBookStatusProvider(bookId));
      ref.invalidate(shelvesByStatusProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Progress saved — marked ${status.actionLabel}.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingProgress = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String bookId = widget.bookId;
    final AsyncValue<HomeBookDetails> detailsAsync = ref.watch(
      homeBookDetailsProvider(bookId),
    );

    return detailsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (Object error, StackTrace stackTrace) {
        return Scaffold(
          body: Center(child: Text('Failed to load book: $error')),
        );
      },
      data: (HomeBookDetails details) {
        final AsyncValue<ShelfBook?> shelfBookAsync = ref.watch(
          homeShelfBookProvider(bookId),
        );

        final int currentPercent = shelfBookAsync.maybeWhen(
          data: (ShelfBook? book) => book?.currentPercent ?? 0,
          orElse: () => 0,
        );

        return Scaffold(
          appBar: AppBar(title: Text(details.title)),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (details.thumbnailUrl != null)
                    Center(child: Image.network(details.thumbnailUrl!)),
                  const SizedBox(height: 12),
                  Text(
                    details.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(details.authors.join(', ')),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: currentPercent / 100),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text('$currentPercent%'),
                      const Spacer(),
                      FilledButton(
                        onPressed: _isSubmittingProgress
                            ? null
                            : () => _handleProgressAction(
                                currentPercent,
                                bookId,
                                details,
                              ),
                        child: const Text('Update Progress'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
