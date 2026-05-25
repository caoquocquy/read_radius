import 'package:book_radius/features/auth/domain/auth_session_state.dart';
import 'package:book_radius/features/auth/presentation/auth_guard_sheet.dart';
import 'package:book_radius/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WallScreen extends ConsumerWidget {
  const WallScreen({super.key});

  static const String routeName = 'wall-screen';
  static const String routePath = '/wall';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AuthSessionState> session = ref.watch(authSessionProvider);
    final AuthSessionState state = session.maybeWhen(
      data: (AuthSessionState value) => value,
      orElse: () => AuthSessionState.guest,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('BookRadius')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              state == AuthSessionState.authenticated
                  ? 'Signed in'
                  : 'Browsing as guest',
            ),
            const SizedBox(height: 12),
            const Text('Wall (Day 1 Placeholder)'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                if (state == AuthSessionState.authenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to shelf.')),
                  );
                  return;
                }

                await showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const AuthGuardSheet(),
                );
              },
              child: const Text('Add To Shelf (Protected Action)'),
            ),
            const SizedBox(height: 8),
            if (state == AuthSessionState.authenticated)
              TextButton(
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signOut(),
                child: const Text('Sign out'),
              ),
          ],
        ),
      ),
    );
  }
}
