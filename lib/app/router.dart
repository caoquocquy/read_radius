import 'package:read_radius/features/wall/presentation/wall_screen.dart';
import 'package:read_radius/features/splash/presentation/splash_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: SplashScreen.routePath,
  routes: <RouteBase>[
    GoRoute(
      path: SplashScreen.routePath,
      name: SplashScreen.routeName,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: WallScreen.routePath,
      name: WallScreen.routeName,
      builder: (context, state) => const WallScreen(),
    ),
  ],
);
