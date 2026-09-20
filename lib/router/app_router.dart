// 🧭 App Router & Navigation Configuration
// 📌 কাজ: অ্যাপের সমস্ত পেজের রুট পাথ নির্ধারণ (Landing, Login, SignUp, Shell, Marketplace, Sell, Subscriptions, Profile)
// 🔗 লাইব্রেরি: GoRouter

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/auth/screens/landing_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/verify_email_screen.dart';
import '../features/marketplace/screens/marketplace_screen.dart';
import '../features/marketplace/screens/product_details_screen.dart';
import '../features/marketplace/screens/sell_item_screen.dart';
import '../features/subscriptions/screens/subscription_groups_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../shared/main_shell_screen.dart';
import '../models/product.dart';

// 🔄 GoRouterRefreshStream for Firebase Auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouter = GoRouter(
  initialLocation: '/landing',
  refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;
    
    // Allowed routes without login
    final isAuthRoute = state.matchedLocation == '/landing' ||
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/signup' ||
        state.matchedLocation == '/verify-email';

    // If user is NOT logged in and trying to access a protected page
    if (!isLoggedIn && !isAuthRoute) {
      return '/landing';
    }

    // If user IS logged in but tries to access login/signup page again
    if (isLoggedIn && isAuthRoute) {
      return '/marketplace';
    }

    return null; // No redirect needed
  },
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
    GoRoute(
      path: '/verify-email',
      pageBuilder: (context, state) => const NoTransitionPage(child: VerifyEmailScreen()),
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

