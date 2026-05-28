import 'package:read_radius/features/auth/presentation/auth_guard_sheet.dart';
import 'package:read_radius/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('auth guard sheet shows login prompt and button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(
            () => _LoadingAuthController(state: const AsyncData<void>(null)),
          ),
        ],
        child: const MaterialApp(home: _AuthSheetWrapper()),
      ),
    );
    await tester.pump();

    expect(find.text('Login with Facebook'), findsWidgets);
    expect(
      find.text(
        'Sign in is required to add books to shelves or write reviews.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('auth guard sheet has tappable login button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(
            () => _LoadingAuthController(state: const AsyncData<void>(null)),
          ),
        ],
        child: const MaterialApp(home: _AuthSheetWrapper()),
      ),
    );
    await tester.pump();

    expect(find.byType(FilledButton), findsOneWidget);
  });
}

/// Helper widget that displays the [AuthGuardSheet] in a modal.
class _AuthSheetWrapper extends StatelessWidget {
  const _AuthSheetWrapper();

  @override
  Widget build(BuildContext context) {
    // Show the sheet immediately so the test can find widgets inside it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet<void>(
        context: context,
        builder: (_) => const AuthGuardSheet(),
      );
    });

    return const Scaffold(body: Center(child: Text('Root')));
  }
}

/// A minimal AuthController override for testing.
class _LoadingAuthController extends AuthController {
  _LoadingAuthController({required this.state});
  @override
  final AsyncValue<void> state;
}
