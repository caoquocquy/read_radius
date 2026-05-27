import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/presentation/auth_guard_sheet.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/book_details/presentation/widgets/book_details_header.dart';
import 'package:read_radius/features/book_details/presentation/widgets/book_meta_section.dart';
import 'package:read_radius/features/book_details/presentation/widgets/book_preview_button.dart';
import 'package:read_radius/features/book_details/presentation/widgets/progress_picker_sheet.dart';
import 'package:read_radius/features/book_details/presentation/widgets/reading_progress_card.dart';
import 'package:read_radius/features/book_details/presentation/widgets/reviews_section.dart';
import 'package:read_radius/features/book_details/presentation/widgets/shelf_action_button.dart';
import 'package:read_radius/features/book_details/presentation/widgets/shelf_status_picker_sheet.dart';
import 'package:read_radius/features/book_details/providers/book_details_providers.dart';
import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/shelves/providers/shelves_providers.dart';
import 'package:read_radius/features/home/domain/home_book.dart';
import 'package:read_radius/features/home/domain/home_book_details.dart';
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

  Future<void> _handleShelfAction({
    required AuthSessionState authState,
    required HomeBookDetails details,
    required ShelfStatus? currentStatus,
  }) async {
    if (authState != AuthSessionState.authenticated) {
      await _showAuthGuardSheet();
      return;
    }

    final ShelfStatus? selectedStatus = await ShelfStatusPickerSheet(
      currentStatus: currentStatus,
    ).show(context);
    if (selectedStatus == null) {
      return;
    }

    setState(() {
      _isSubmittingShelfAction = true;
    });

    try {
      await ref
          .read(bookShelfActionControllerProvider.notifier)
          .setBookStatus(book: _toHomeBook(details), status: selectedStatus);

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
    required HomeBookDetails details,
    required ShelfStatus? currentStatus,
    required int currentPercent,
  }) async {
    if (authState != AuthSessionState.authenticated) {
      await _showAuthGuardSheet();
      return;
    }

    if (currentStatus != ShelfStatus.reading) {
      return;
    }

    final int? selectedPercent = await ProgressPickerSheet(
      currentPercent: currentPercent,
    ).show(context);
    if (selectedPercent == null) {
      return;
    }

    setState(() {
      _isSubmittingProgress = true;
    });

    try {
      final ShelfStatus nextStatus = await ref
          .read(bookReadingProgressControllerProvider.notifier)
          .updateProgress(details: details, currentPercent: selectedPercent);

      final ShelfBook? refreshedShelfBook = await ref.refresh(
        bookShelfEntryProvider(details.id).future,
      );
      final ShelfStatus? refreshedStatus = await ref.refresh(
        bookShelfStatusProvider(details.id).future,
      );
      final Map<ShelfStatus, List<ShelfBook>> refreshedShelves = await ref
          .refresh(shelvesByStatusProvider.future);
      final bool isInCompletedShelf =
          (refreshedShelves[ShelfStatus.completed] ?? const <ShelfBook>[]).any(
            (ShelfBook book) => book.bookId == details.id,
          );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (refreshedStatus ?? nextStatus) == ShelfStatus.completed ||
                    isInCompletedShelf
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

  HomeBook _toHomeBook(HomeBookDetails details) {
    return HomeBook(
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

    final AsyncValue<HomeBookDetails> detailsAsync = ref.watch(
      bookDetailsProvider(widget.bookId),
    );
    final AsyncValue<ShelfStatus?> statusAsync = ref.watch(
      bookShelfStatusProvider(widget.bookId),
    );
    final AsyncValue<ShelfBook?> shelfBookAsync = ref.watch(
      bookShelfEntryProvider(widget.bookId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Book Details')),
      body: SafeArea(
        child: detailsAsync.when(
          data: (HomeBookDetails details) {
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
                ref.watch(bookShelfActionControllerProvider).isLoading;
            final bool isProgressBusy =
                _isSubmittingProgress ||
                ref.watch(bookReadingProgressControllerProvider).isLoading;
            final int displayedPercent = (shelfBook?.currentPercent ?? 0)
                .clamp(0, 100)
                .toInt();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: <Widget>[
                BookDetailsHeader(
                  thumbnailUrl: details.thumbnailUrl,
                  title: details.title,
                  authors: details.authors,
                ),
                const SizedBox(height: 16),
                BookMetaSection(details: details),
                const SizedBox(height: 20),
                ShelfActionButton(
                  currentStatus: currentStatus,
                  isBusy: isActionBusy,
                  isDisabled: statusLoading,
                  onPressed: () {
                    _handleShelfAction(
                      authState: authState,
                      details: details,
                      currentStatus: currentStatus,
                    );
                  },
                ),
                if (currentStatus == ShelfStatus.reading) ...<Widget>[
                  const SizedBox(height: 12),
                  ReadingProgressCard(
                    displayedPercent: displayedPercent,
                    isBusy: isProgressBusy,
                    onUpdateProgress: () {
                      _handleProgressAction(
                        authState: authState,
                        details: details,
                        currentStatus: currentStatus,
                        currentPercent: displayedPercent,
                      );
                    },
                  ),
                ],
                if (details.previewLink != null) ...<Widget>[
                  const SizedBox(height: 8),
                  BookPreviewButton(
                    onPressed: () => _openPreview(details.previewLink),
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
                ReviewsSection(
                  onWriteReview: () => _handleWriteReview(authState),
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
