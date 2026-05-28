import 'package:read_radius/features/auth/domain/auth_session_state.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:read_radius/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('guest profile shows sign-in message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionProvider.overrideWith(
            (Ref ref) => Stream<AuthSessionState>.value(AuthSessionState.guest),
          ),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );

    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Sign in to access account actions.'), findsOneWidget);
    expect(find.text('Sign out'), findsNothing);
  });

  testWidgets('authenticated profile shows sign out button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionProvider.overrideWith(
            (Ref ref) =>
                Stream<AuthSessionState>.value(AuthSessionState.authenticated),
          ),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );

    expect(find.text('Account'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    expect(find.text('Sign in to access account actions.'), findsNothing);

    await tester.tap(find.text('Sign out'));
    await tester.pump();

    expect(find.text('Signing out...'), findsOneWidget);
  });

  testWidgets('signing out shows signing out text and disables button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionProvider.overrideWith(
            (Ref ref) =>
                Stream<AuthSessionState>.value(AuthSessionState.authenticated),
          ),
          authControllerProvider.overrideWith(
            () => _TestAuthController(state: const AsyncLoading<void>()),
          ),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('Signing out...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

class _TestAuthController extends AuthController {
  _TestAuthController({required this.state});
  @override
  final AsyncValue<void> state;
}
