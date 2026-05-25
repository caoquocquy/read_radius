import 'package:book_radius/features/book_wall/presentation/guest_home_screen.dart';
import 'package:book_radius/features/splash/presentation/splash_screen.dart';
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
      path: GuestHomeScreen.routePath,
      name: GuestHomeScreen.routeName,
      builder: (context, state) => const GuestHomeScreen(),
    ),
  ],
);
