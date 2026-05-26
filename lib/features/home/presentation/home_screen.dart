import 'dart:async';

import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/presentation/auth_guard_sheet.dart';
import 'package:read_radius/features/auth/presentation/widgets/user_photo_avatar_button.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/profile/presentation/profile_screen.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/home/domain/home_book.dart';
import 'package:read_radius/features/home/presentation/book_details_screen.dart';
import 'package:read_radius/features/home/presentation/widgets/home_books_collection.dart';
import 'package:read_radius/features/home/presentation/widgets/home_view_mode_toggle.dart';
import 'package:read_radius/features/home/providers/home_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = 'home-screen';
  static const String routePath = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Timer? _debounce;
  String? _pendingActionBookId;

  Future<void> _showAuthGuardSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AuthGuardSheet(),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
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

  Future<void> _handleBookAction({
    required AuthSessionState state,
    required HomeBook book,
    required ShelfStatus? currentStatus,
  }) async {
    if (state != AuthSessionState.authenticated) {
      await _showAuthGuardSheet();
      return;
    }

    final ShelfStatus? selectedStatus = await _pickShelfStatus(currentStatus);
    if (selectedStatus == null) {
      return;
    }

    setState(() {
      _pendingActionBookId = book.id;
    });

    try {
      await ref
          .read(homeShelfActionControllerProvider.notifier)
          .setBookStatus(book: book, status: selectedStatus);

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
          _pendingActionBookId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AuthSessionState> session = ref.watch(authSessionProvider);
    final AsyncValue<String?> photoUrl = ref.watch(authUserPhotoUrlProvider);
    final AuthSessionState state = session.maybeWhen(
      data: (AuthSessionState value) => value,
      orElse: () => AuthSessionState.guest,
    );
    final String query = ref.watch(homeSearchQueryProvider);
    final AsyncValue<List<HomeBook>> search = ref.watch(
      homeSearchResultsProvider,
    );
    final AsyncValue<List<HomeBook>> trending = ref.watch(
      homeTrendingResultsProvider,
    );
    final AsyncValue<Map<String, ShelfStatus>> statusMapAsync = ref.watch(
      homeBookStatusesProvider,
    );
    final AsyncValue<void> actionState = ref.watch(
      homeShelfActionControllerProvider,
    );
    final HomeBooksViewMode viewMode = ref.watch(homeViewModeProvider);
    final Map<String, ShelfStatus> statusMap = statusMapAsync.maybeWhen(
      data: (Map<String, ShelfStatus> value) => value,
      orElse: () => <String, ShelfStatus>{},
    );

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 52,
        leading: UserPhotoAvatarButton(
          authState: state,
          photoUrl: photoUrl,
          onGuestTap: _showAuthGuardSheet,
          onAuthenticatedTap: () {
            context.pushNamed(ProfileScreen.routeName);
          },
        ),
        titleSpacing: 8,
        title: SizedBox(
          height: 40,
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search books on Google Books',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (String value) {
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 450), () {
                if (!mounted) return;
                ref.read(homeSearchQueryProvider.notifier).setQuery(value);
              });
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              HomeViewModeToggle(
                mode: viewMode,
                onModeSelected: (HomeBooksViewMode selected) {
                  ref.read(homeViewModeProvider.notifier).setMode(selected);
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: query.isEmpty
                    ? trending.when(
                        data: (List<HomeBook> books) {
                          if (books.isEmpty) {
                            return const Center(
                              child: Text('No trending books right now.'),
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Trending now',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: HomeBooksCollection(
                                  books: books,
                                  viewMode: viewMode,
                                  enableThumbnail: true,
                                  actionLabelBuilder: (HomeBook book) {
                                    final ShelfStatus? status =
                                        statusMap[book.id];
                                    return status?.actionLabel ??
                                        'Want to Read';
                                  },
                                  onBookTap: (HomeBook book) {
                                    context.pushNamed(
                                      BookDetailsScreen.routeName,
                                      pathParameters: <String, String>{
                                        'bookId': book.id,
                                      },
                                    );
                                  },
                                  onActionPressed: (HomeBook book) {
                                    _handleBookAction(
                                      state: state,
                                      book: book,
                                      currentStatus: statusMap[book.id],
                                    );
                                  },
                                  isActionLoading: (HomeBook book) {
                                    return actionState.isLoading &&
                                        _pendingActionBookId == book.id;
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (Object error, StackTrace stackTrace) {
                          return Center(child: Text('Trending failed: $error'));
                        },
                      )
                    : search.when(
                        data: (List<HomeBook> books) {
                          if (books.isEmpty) {
                            return const Center(
                              child: Text('No books found for this query.'),
                            );
                          }

                          return HomeBooksCollection(
                            books: books,
                            viewMode: viewMode,
                            enableThumbnail: true,
                            actionLabelBuilder: (HomeBook book) {
                              final ShelfStatus? status = statusMap[book.id];
                              return status?.actionLabel ?? 'Want to Read';
                            },
                            onBookTap: (HomeBook book) {
                              context.pushNamed(
                                BookDetailsScreen.routeName,
                                pathParameters: <String, String>{
                                  'bookId': book.id,
                                },
                              );
                            },
                            onActionPressed: (HomeBook book) {
                              _handleBookAction(
                                state: state,
                                book: book,
                                currentStatus: statusMap[book.id],
                              );
                            },
                            isActionLoading: (HomeBook book) {
                              return actionState.isLoading &&
                                  _pendingActionBookId == book.id;
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (Object error, StackTrace stackTrace) {
                          return Center(child: Text('Search failed: $error'));
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
