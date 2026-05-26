import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/presentation/auth_guard_sheet.dart';
import 'package:read_radius/features/auth/presentation/widgets/user_photo_avatar_button.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/profile/presentation/profile_screen.dart';
import 'package:read_radius/features/shelves/domain/shelf_book.dart';
import 'package:read_radius/features/shelves/domain/shelf_status.dart';
import 'package:read_radius/features/shelves/domain/shelves_repository.dart';
import 'package:read_radius/features/shelves/presentation/widgets/shelves_section.dart';
import 'package:read_radius/features/shelves/providers/shelves_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShelvesScreen extends ConsumerWidget {
  const ShelvesScreen({super.key});

  static const String routeName = 'shelves-screen';
  static const String routePath = '/shelves';

  Future<void> _showAuthGuardSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AuthGuardSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AuthSessionState> session = ref.watch(authSessionProvider);
    final AsyncValue<String?> photoUrl = ref.watch(authUserPhotoUrlProvider);
    final AuthSessionState authState = session.maybeWhen(
      data: (AuthSessionState value) => value,
      orElse: () => AuthSessionState.guest,
    );

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 52,
        leading: UserPhotoAvatarButton(
          authState: authState,
          photoUrl: photoUrl,
          onGuestTap: () {
            _showAuthGuardSheet(context);
          },
          onAuthenticatedTap: () {
            context.pushNamed(ProfileScreen.routeName);
          },
        ),
        title: const Text('Shelves'),
      ),
      body: SafeArea(
        child: authState == AuthSessionState.guest
            ? _GuestShelvesPlaceholder(
                onAuthenticatePressed: () => _showAuthGuardSheet(context),
              )
            : _AuthenticatedShelvesBody(),
      ),
    );
  }
}

class _GuestShelvesPlaceholder extends StatelessWidget {
  const _GuestShelvesPlaceholder({required this.onAuthenticatePressed});

  final VoidCallback onAuthenticatePressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.collections_bookmark_outlined,
              size: 44,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            const Text(
              'Sign in to see your shelves',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Track books across Want to Read, Reading, and Completed.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onAuthenticatePressed,
              child: const Text('Continue with Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthenticatedShelvesBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ShelvesByStatus> shelvesAsync = ref.watch(
      shelvesByStatusProvider,
    );

    return shelvesAsync.when(
      data: (ShelvesByStatus shelves) {
        final int totalCount = shelves.values.fold<int>(
          0,
          (int sum, List<ShelfBook> books) => sum + books.length,
        );

        if (totalCount == 0) {
          return const Center(child: Text('No books in your shelves yet.'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            ShelvesSection(
              title: ShelfStatus.wantToRead.label,
              books: shelves[ShelfStatus.wantToRead] ?? const <ShelfBook>[],
            ),
            const SizedBox(height: 16),
            ShelvesSection(
              title: ShelfStatus.reading.label,
              books: shelves[ShelfStatus.reading] ?? const <ShelfBook>[],
            ),
            const SizedBox(height: 16),
            ShelvesSection(
              title: ShelfStatus.completed.label,
              books: shelves[ShelfStatus.completed] ?? const <ShelfBook>[],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace stackTrace) {
        return Center(child: Text('Failed to load shelves: $error'));
      },
    );
  }
}
