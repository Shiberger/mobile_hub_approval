import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF1A73E8);
  static const Color secondaryColor = Color(0xFF5F6368);
  static const Color pendingColor = Color(0xFFFFA000);
  static const Color approvedColor = Color(0xFF34A853);
  static const Color rejectedColor = Color(0xFFEA4335);
  static const Color surfaceColor = Color(0xFFF8F9FA);
  static const Color onSurfaceColor = Color(0xFF202124);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          surface: surfaceColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: onSurfaceColor,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
}
