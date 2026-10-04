import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2563EB),
        primaryContainer: Color(0xFFEEF2FF),
        secondary: Color(0xFF059669),
        surface: Colors.white,
        surfaceContainerHighest: Color(0xFFF1F5F9),
        onSurface: Color(0xFF0F172A),
        onSurfaceVariant: Color(0xFF64748B),
        outline: Color(0xFFCBD5E1),
        outlineVariant: Color(0xFFE2E8F0),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE2E8F0),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF0F172A),
      ),
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF3B82F6),
        primaryContainer: Color(0xFF1E3A8A),
        secondary: Color(0xFF10B981),
        surface: Color(0xFF12141C),
        surfaceContainerHighest: Color(0xFF1B1E2B),
        onSurface: Color(0xFFF9FAFB),
        onSurfaceVariant: Color(0xFF9CA3AF),
        outline: Color(0xFF262B3A),
        outlineVariant: Color(0xFF1D212E),
      ),
      scaffoldBackgroundColor: const Color(0xFF090A0E),
      cardColor: const Color(0xFF12141C),
      dividerColor: const Color(0xFF1D212E),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF12141C),
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF262B3A)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF0E1017),
        foregroundColor: Color(0xFFF9FAFB),
      ),
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF12141C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF262B3A)),
        ),
      ),
    );
  }
}

extension AppThemeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  Color get surfaceColor => isDarkMode ? const Color(0xFF12141C) : Colors.white;
  Color get cardBg => isDarkMode ? const Color(0xFF12141C) : Colors.white;
  Color get secondaryBg => isDarkMode ? const Color(0xFF090A0E) : const Color(0xFFF8FAFC);
  Color get containerBg => isDarkMode ? const Color(0xFF181A24) : const Color(0xFFF1F5F9);
  Color get inputFill => isDarkMode ? const Color(0xFF151722) : const Color(0xFFF8FAFC);
  Color get borderColor => isDarkMode ? const Color(0xFF262B3A) : const Color(0xFFE2E8F0);
  Color get textPrimary => isDarkMode ? const Color(0xFFF9FAFB) : const Color(0xFF0F172A);
  Color get textSecondary => isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get textMuted => isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
  Color get primaryAccent => isDarkMode ? const Color(0xFF3B82F6) : const Color(0xFF2563EB);
  Color get primaryContainerBg => isDarkMode ? const Color(0xFF1E3A8A).withValues(alpha: 0.35) : const Color(0xFFEEF2FF);
}

