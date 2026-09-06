import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  PaintingBinding.instance.imageCache.maximumSize = 1000;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 300 << 20; // 300 MB memory cache
  runApp(const ProviderScope(child: StudentMarketplaceApp()));
}

class SmoothWebScrollBehavior extends MaterialScrollBehavior {
  const SmoothWebScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(
        parent: RangeMaintainingScrollPhysics(),
      ),
    );
  }

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return RawScrollbar(
      controller: details.controller,
      thumbVisibility: false,
      trackVisibility: false,
      radius: const Radius.circular(8),
      thickness: 6,
      fadeDuration: const Duration(milliseconds: 300),
      timeToFade: const Duration(milliseconds: 1200),
      thumbColor: const Color(0xFF94A3B8).withValues(alpha: 0.6),
      child: child,
    );
  }
}

class StudentMarketplaceApp extends ConsumerWidget {
  const StudentMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Student Marketplace',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const SmoothWebScrollBehavior(),
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
    );
  }
}
