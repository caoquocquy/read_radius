import 'package:read_radius/core/providers/startup_provider.dart';
import 'package:read_radius/features/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:read_radius/app/app.dart';

void main() {
  testWidgets('splash shows loading indicator while startup runs', (
    WidgetTester tester,
  ) async {
    final ProviderContainer container = ProviderContainer(
      overrides: [
        startupProvider.overrideWith(
          (Ref ref) => Future<void>.delayed(const Duration(seconds: 10)),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: SplashScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('splash navigates to home on startup success', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [startupProvider.overrideWith((Ref ref) async {})],
        child: const ReadRadiusApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Search books on Google Books'), findsOneWidget);
  });

  testWidgets('splash navigates to home on startup error', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          startupProvider.overrideWith(
            (Ref ref) async => throw Exception('Startup failed'),
          ),
        ],
        child: const ReadRadiusApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Search books on Google Books'), findsOneWidget);
  });
}
