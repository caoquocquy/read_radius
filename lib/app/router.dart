import 'package:read_radius/app/app_tab_scaffold.dart';
import 'package:read_radius/features/profile/presentation/profile_screen.dart';
import 'package:read_radius/features/shelves/presentation/shelves_screen.dart';
import 'package:read_radius/features/wall/presentation/book_details_screen.dart';
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppTabScaffold(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: WallScreen.routePath,
              name: WallScreen.routeName,
              builder: (context, state) => const WallScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: ShelvesScreen.routePath,
              name: ShelvesScreen.routeName,
              builder: (context, state) => const ShelvesScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: ProfileScreen.routePath,
      name: ProfileScreen.routeName,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: BookDetailsScreen.routePath,
      name: BookDetailsScreen.routeName,
      builder: (context, state) {
        final String bookId = state.pathParameters['bookId'] ?? '';
        return BookDetailsScreen(bookId: bookId);
      },
    ),
  ],
);
