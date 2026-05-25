import 'dart:async';

import 'package:book_radius/features/auth/domain/auth_session_state.dart';
import 'package:book_radius/features/auth/presentation/auth_guard_sheet.dart';
import 'package:book_radius/features/auth/providers/auth_providers.dart';
import 'package:book_radius/features/wall/domain/wall_book.dart';
import 'package:book_radius/features/wall/providers/wall_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WallScreen extends ConsumerStatefulWidget {
  const WallScreen({super.key});

  static const String routeName = 'wall-screen';
  static const String routePath = '/wall';

  @override
  ConsumerState<WallScreen> createState() => _WallScreenState();
}

class _WallScreenState extends ConsumerState<WallScreen> {
  Timer? _debounce;

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

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AuthGuardSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AuthSessionState> session = ref.watch(authSessionProvider);
    final AuthSessionState state = session.maybeWhen(
      data: (AuthSessionState value) => value,
      orElse: () => AuthSessionState.guest,
    );
    final String query = ref.watch(wallSearchQueryProvider);
    final AsyncValue<List<WallBook>> search = ref.watch(
      wallSearchResultsProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('BookRadius')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                state == AuthSessionState.authenticated
                    ? 'Signed in'
                    : 'Browsing as guest',
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search books on Google Books',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 450), () {
                    if (!mounted) return;
                    ref.read(wallSearchQueryProvider.notifier).setQuery(value);
                  });
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: query.isEmpty
                    ? const Center(
                        child: Text('Search for a title, author, or keyword.'),
                      )
                    : search.when(
                        data: (List<WallBook> books) {
                          if (books.isEmpty) {
                            return const Center(
                              child: Text('No books found for this query.'),
                            );
                          }

                          return ListView.separated(
                            itemCount: books.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(height: 8),
                            itemBuilder: (BuildContext context, int index) {
                              final WallBook book = books[index];
                              final String subtitle = book.authors.isEmpty
                                  ? 'Unknown author'
                                  : book.authors.join(', ');

                              return Card(
                                child: ListTile(
                                  title: Text(book.title),
                                  subtitle: Text(subtitle),
                                  trailing: FilledButton.tonal(
                                    onPressed: () =>
                                        _handleProtectedAction(state),
                                    child: const Text('Add'),
                                  ),
                                ),
                              );
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
              if (state == AuthSessionState.authenticated)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        ref.read(authControllerProvider.notifier).signOut(),
                    child: const Text('Sign out'),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleProtectedAction(state),
        label: const Text('Protected Action'),
        icon: const Icon(Icons.lock_outline),
      ),
    );
  }
}
