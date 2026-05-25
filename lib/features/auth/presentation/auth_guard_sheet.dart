import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGuardSheet extends ConsumerStatefulWidget {
  const AuthGuardSheet({super.key});

  @override
  ConsumerState<AuthGuardSheet> createState() => _AuthGuardSheetState();
}

class _AuthGuardSheetState extends ConsumerState<AuthGuardSheet> {
  bool _didRequestLogin = false;
  late final ProviderSubscription<AsyncValue<void>> _authControllerSub;

  @override
  void initState() {
    super.initState();
    _authControllerSub = ref.listenManual<AsyncValue<void>>(
      authControllerProvider,
      (previous, next) {
        if (!_didRequestLogin) {
          return;
        }

        if (previous?.isLoading != true) {
          return;
        }

        if (next.hasValue) {
          _didRequestLogin = false;
          if (!mounted) {
            return;
          }
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signed in with Facebook.')),
          );
          return;
        }

        next.whenOrNull(
          error: (error, _) {
            _didRequestLogin = false;
            if (!mounted) {
              return;
            }
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(error.toString())));
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _authControllerSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<void> state = ref.watch(authControllerProvider);
    final bool isLoading = state.isLoading;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Login with Facebook',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in is required to add books to shelves or write reviews.',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isLoading
                    ? null
                    : () {
                        setState(() {
                          _didRequestLogin = true;
                        });
                        ref
                            .read(authControllerProvider.notifier)
                            .continueWithFacebook();
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login with Facebook'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
