import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/presentation/auth_guard_sheet.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/wall/domain/wall_book.dart';
import 'package:read_radius/features/wall/domain/wall_book_details.dart';
import 'package:read_radius/features/wall/providers/wall_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailsScreen extends ConsumerStatefulWidget {
  const BookDetailsScreen({required this.bookId, super.key});

  static const String routeName = 'book-details-screen';
  static const String routePath = '/books/:bookId';

  final String bookId;

  @override
  ConsumerState<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  bool _isSubmittingShelfAction = false;
  bool _isSubmittingProgress = false;

  Future<void> _showAuthGuardSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AuthGuardSheet(),
    );
  }

  Future<ShelfStatus?> _pickShelfStatus(ShelfStatus? currentStatus) {
    return showModalBottomSheet<ShelfStatus>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ShelfStatus.values
                .map((ShelfStatus status) {
                  final bool isSelected = status == currentStatus;
                  return ListTile(
                    leading: isSelected
                        ? const Icon(Icons.check_rounded)
                        : const SizedBox(width: 24),
                    title: Text(status.actionLabel),
                    onTap: () {
                      Navigator.of(context).pop(status);
                    },
                  );
                })
                .toList(growable: false),
          ),
        );
      },
    );
  }

  Future<void> _handleShelfAction({
    required AuthSessionState authState,
    required WallBookDetails details,
    required ShelfStatus? currentStatus,
  }) async {
    if (authState != AuthSessionState.authenticated) {
      await _showAuthGuardSheet();
      return;
    }

    final ShelfStatus? selectedStatus = await _pickShelfStatus(currentStatus);
    if (selectedStatus == null) {
      return;
    }

    setState(() {
      _isSubmittingShelfAction = true;
    });

    try {
      await ref
          .read(wallShelfActionControllerProvider.notifier)
          .setBookStatus(book: _toWallBook(details), status: selectedStatus);

      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved as ${selectedStatus.actionLabel}.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingShelfAction = false;
        });
      }
    }
  }

  Future<void> _openPreview(String? previewLink) async {
    final String? normalizedLink = previewLink?.trim();
    if (normalizedLink == null || normalizedLink.isEmpty) {
      return;
    }

    final Uri? uri = Uri.tryParse(normalizedLink);
    if (uri == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid preview link.')));
      return;
    }

    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open preview link.')),
      );
    }
  }

  Future<void> _handleWriteReview(AuthSessionState authState) async {
    if (authState != AuthSessionState.authenticated) {
      await _showAuthGuardSheet();
      return;
    }

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Write review is coming soon.')),
    );
  }

  Future<void> _handleProgressAction({
    required AuthSessionState authState,
    required WallBookDetails details,
    required ShelfStatus? currentStatus,
    required int selectedPercent,
  }) async {
    if (authState != AuthSessionState.authenticated) {
      await _showAuthGuardSheet();
      return;
    }

    if (currentStatus != ShelfStatus.reading) {
      return;
    }

    setState(() {
      _isSubmittingProgress = true;
    });

    try {
      final ShelfStatus nextStatus = await ref
          .read(wallReadingProgressControllerProvider.notifier)
          .updateProgress(details: details, currentPercent: selectedPercent);

      // Force immediate re-fetch so the progress card reflects latest values.
      final ShelfBook? refreshedShelfBook = await ref.refresh(
        wallShelfBookProvider(details.id).future,
      );
      final ShelfStatus? refreshedStatus = await ref.refresh(
        wallBookStatusProvider(details.id).future,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (refreshedStatus ?? nextStatus) == ShelfStatus.completed
                ? 'Progress updated. Marked as Read.'
                : refreshedShelfBook == null
                ? 'Progress updated.'
                : 'Reading progress updated.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingProgress = false;
        });
      }
    }
  }

  WallBook _toWallBook(WallBookDetails details) {
    return WallBook(
      id: details.id,
      title: details.title,
      authors: details.authors,
      thumbnailUrl: details.thumbnailUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AuthSessionState> session = ref.watch(authSessionProvider);
    final AuthSessionState authState = session.maybeWhen(
      data: (AuthSessionState value) => value,
      orElse: () => AuthSessionState.guest,
    );

    final AsyncValue<WallBookDetails> detailsAsync = ref.watch(
      wallBookDetailsProvider(widget.bookId),
    );
    final AsyncValue<ShelfStatus?> statusAsync = ref.watch(
      wallBookStatusProvider(widget.bookId),
    );
    final AsyncValue<ShelfBook?> shelfBookAsync = ref.watch(
      wallShelfBookProvider(widget.bookId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: SafeArea(
        child: detailsAsync.when(
          data: (WallBookDetails details) {
            final ShelfStatus? currentStatus = statusAsync.maybeWhen(
              data: (ShelfStatus? value) => value,
              orElse: () => null,
            );
            final ShelfBook? shelfBook = shelfBookAsync.maybeWhen(
              data: (ShelfBook? value) => value,
              orElse: () => null,
            );
            final bool statusLoading = statusAsync.isLoading;
            final bool isActionBusy =
                _isSubmittingShelfAction ||
                ref.watch(wallShelfActionControllerProvider).isLoading;
            final bool isProgressBusy =
                _isSubmittingProgress ||
                ref.watch(wallReadingProgressControllerProvider).isLoading;
            final int displayedPercent = (shelfBook?.currentPercent ?? 0)
                .clamp(0, 100)
                .toInt();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _BookCover(url: details.thumbnailUrl),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            details.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            details.authors.isEmpty
                                ? 'Unknown author'
                                : details.authors.join(', '),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    if (details.publisher != null)
                      _MetaChip(label: 'Publisher', value: details.publisher!),
                    if (details.publishedDate != null)
                      _MetaChip(
                        label: 'Published',
                        value: details.publishedDate!,
                      ),
                    if (details.pageCount != null)
                      _MetaChip(
                        label: 'Pages',
                        value: details.pageCount!.toString(),
                      ),
                  ],
                ),
                if (details.categories.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: details.categories
                        .map((String category) => Chip(label: Text(category)))
                        .toList(growable: false),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton.tonalIcon(
                  onPressed: isActionBusy || statusLoading
                      ? null
                      : () {
                          _handleShelfAction(
                            authState: authState,
                            details: details,
                            currentStatus: currentStatus,
                          );
                        },
                  icon: isActionBusy
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.collections_bookmark_outlined),
                  label: Text(currentStatus?.actionLabel ?? 'Add to Shelf'),
                ),
                if (currentStatus == ShelfStatus.reading) ...<Widget>[
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Reading Progress',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 6),
                          Text('Current progress: $displayedPercent%'),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: displayedPercent / 100,
                          ),
                          const SizedBox(height: 10),
                          if (isProgressBusy)
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              for (final int value in <int>[
                                10,
                                20,
                                30,
                                40,
                                50,
                                60,
                                70,
                                80,
                                90,
                                100,
                              ])
                                ChoiceChip(
                                  label: Text('$value%'),
                                  selected: displayedPercent == value,
                                  onSelected: isProgressBusy
                                      ? null
                                      : (_) {
                                          _handleProgressAction(
                                            authState: authState,
                                            details: details,
                                            currentStatus: currentStatus,
                                            selectedPercent: value,
                                          );
                                        },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (details.previewLink != null) ...<Widget>[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      _openPreview(details.previewLink);
                    },
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Open Google Books Preview'),
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  'About this book',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  details.description ??
                      'No description is available for this book yet.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Text('Reviews', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                const Text(
                  'Reviews are coming soon. You can already add this book to your shelves.',
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    _handleWriteReview(authState);
                  },
                  icon: const Icon(Icons.rate_review_outlined),
                  label: const Text('Write Review'),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Failed to load book details: $error'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({required this.url});

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

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}
