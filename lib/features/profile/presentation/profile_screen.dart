import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = 'profile-screen';
  static const String routePath = '/profile';

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _didRequestSignOut = false;
  bool _isClosing = false;
  late final ProviderSubscription<AsyncValue<AuthSessionState>> _authSessionSub;

  @override
  void initState() {
    super.initState();
    _authSessionSub = ref.listenManual<AsyncValue<AuthSessionState>>(
      authSessionProvider,
      (_, next) {
        if (!_didRequestSignOut || !mounted || _isClosing) {
          return;
        }

        next.whenOrNull(
          data: (AuthSessionState value) {
            if (value != AuthSessionState.guest) {
              return;
            }

            _didRequestSignOut = false;
            _isClosing = true;
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _authSessionSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<AuthSessionState> session = ref.watch(authSessionProvider);
    final AsyncValue<void> authControllerState = ref.watch(
      authControllerProvider,
    );
    final AuthSessionState state = session.maybeWhen(
      data: (AuthSessionState value) => value,
      orElse: () => AuthSessionState.guest,
    );
    final bool isSigningOut = authControllerState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              if (state == AuthSessionState.authenticated)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: isSigningOut
                        ? null
                        : () {
                            _didRequestSignOut = true;
                            ref.read(authControllerProvider.notifier).signOut();
                          },
                    icon: isSigningOut
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.logout_rounded),
                    label: Text(isSigningOut ? 'Signing out...' : 'Sign out'),
                  ),
                )
              else
                const Text('Sign in to access account actions.'),
            ],
          ),
        ),
      ),
    );
  }
}
