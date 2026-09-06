import 'package:go_router/go_router.dart';
import '../features/auth/screens/landing_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/marketplace/screens/marketplace_screen.dart';
import '../features/marketplace/screens/product_details_screen.dart';
import '../features/marketplace/screens/sell_item_screen.dart';
import '../features/subscriptions/screens/subscription_groups_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../shared/main_shell_screen.dart';
import '../models/product.dart';

final appRouter = GoRouter(
  initialLocation: '/landing',
  routes: [
    // Auth Routes
    GoRoute(
      path: '/landing',
      pageBuilder: (context, state) => const NoTransitionPage(child: LandingScreen()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => const NoTransitionPage(child: LoginScreen()),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) => const NoTransitionPage(child: SignUpScreen()),
    ),

    // Main App Shell Route
    ShellRoute(
      builder: (context, state, child) => MainShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/marketplace',
          pageBuilder: (context, state) => const NoTransitionPage(child: MarketplaceScreen()),
        ),
        GoRoute(
          path: '/sell',
          pageBuilder: (context, state) => const NoTransitionPage(child: SellItemScreen()),
        ),
        GoRoute(
          path: '/subscriptions',
          pageBuilder: (context, state) => const NoTransitionPage(child: SubscriptionGroupsScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),

    // Details Route
    GoRoute(
      path: '/product-details',
      pageBuilder: (context, state) {
        final product = state.extra as Product?;
        return NoTransitionPage(child: ProductDetailsScreen(product: product));
      },
    ),
  ],
);

