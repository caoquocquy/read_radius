import 'package:book_radius/core/providers/startup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  static const String routeName = 'splash';
  static const String routePath = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<void> startup = ref.watch(startupProvider);

    return startup.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.go('/wall');
          }
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
      data: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            context.go('/wall');
          }
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
