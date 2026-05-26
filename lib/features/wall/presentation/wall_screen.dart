import 'dart:async';

import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/presentation/auth_guard_sheet.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/profile/presentation/profile_screen.dart';
import 'package:read_radius/features/wall/domain/wall_book.dart';
import 'package:read_radius/features/wall/presentation/widgets/wall_books_collection.dart';
import 'package:read_radius/features/wall/presentation/widgets/wall_view_mode_toggle.dart';
import 'package:read_radius/features/wall/providers/wall_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WallScreen extends ConsumerStatefulWidget {
  const WallScreen({super.key});

  static const String routeName = 'wall-screen';
  static const String routePath = '/wall';
  static const bool enableTrendingBooks = false;
  static const bool enableThumbnail = false;

  @override
  ConsumerState<WallScreen> createState() => _WallScreenState();
}

class _WallScreenState extends ConsumerState<WallScreen> {
  Timer? _debounce;

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

  Future<void> _handleProtectedAction(AuthSessionState state) async {
    if (state == AuthSessionState.authenticated) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Added to shelf.')));
      return;
    }

    await _showAuthGuardSheet();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AuthSessionState> session = ref.watch(authSessionProvider);
    final AsyncValue<String?> photoUrl = ref.watch(authUserPhotoUrlProvider);
    final AuthSessionState state = session.maybeWhen(
      data: (AuthSessionState value) => value,
      orElse: () => AuthSessionState.guest,
    );
    final String query = ref.watch(wallSearchQueryProvider);
    final AsyncValue<List<WallBook>> search = ref.watch(
      wallSearchResultsProvider,
    );
    final AsyncValue<List<WallBook>>? trending = WallScreen.enableTrendingBooks
        ? ref.watch(wallTrendingResultsProvider)
        : null;
    final WallBooksViewMode viewMode = ref.watch(wallViewModeProvider);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 52,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                if (state == AuthSessionState.guest) {
                  _showAuthGuardSheet();
                  return;
                }

                context.pushNamed(ProfileScreen.routeName);
              },
              child: photoUrl.when(
                data: (String? value) {
                  final String? trimmed = value?.trim();
                  if (trimmed == null || trimmed.isEmpty) {
                    return const CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person, size: 18),
                    );
                  }

                  return CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(trimmed),
                  );
                },
                loading: () => const CircleAvatar(
                  radius: 16,
                  child: SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (_, _) => const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.person, size: 18),
                ),
              ),
            ),
          ),
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
                ref.read(wallSearchQueryProvider.notifier).setQuery(value);
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
              WallViewModeToggle(
                mode: viewMode,
                onModeSelected: (WallBooksViewMode selected) {
                  ref.read(wallViewModeProvider.notifier).setMode(selected);
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: query.isEmpty
                    ? WallScreen.enableTrendingBooks
                          ? trending!.when(
                              data: (List<WallBook> books) {
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
                                      child: WallBooksCollection(
                                        books: books,
                                        viewMode: viewMode,
                                        enableThumbnail:
                                            WallScreen.enableThumbnail,
                                        onAddPressed: () {
                                          _handleProtectedAction(state);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (Object error, StackTrace stackTrace) {
                                return Center(
                                  child: Text('Trending failed: $error'),
                                );
                              },
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text('Trending is temporarily disabled.'),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: WallBooksCollection(
                                    books: const <WallBook>[],
                                    viewMode: viewMode,
                                    enableThumbnail: WallScreen.enableThumbnail,
                                    onAddPressed: () {
                                      _handleProtectedAction(state);
                                    },
                                  ),
                                ),
                              ],
                            )
                    : search.when(
                        data: (List<WallBook> books) {
                          if (books.isEmpty) {
                            return const Center(
                              child: Text('No books found for this query.'),
                            );
                          }

                          return WallBooksCollection(
                            books: books,
                            viewMode: viewMode,
                            enableThumbnail: WallScreen.enableThumbnail,
                            onAddPressed: () {
                              _handleProtectedAction(state);
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
