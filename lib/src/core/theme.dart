import 'package:flutter/material.dart';

class AppColors {
  static const ink = Color(0xFF202038);
  static const muted = Color(0xFF7B7D98);
  static const violet = Color(0xFF7044D8);
  static const violetDark = Color(0xFF47227D);
  static const lavender = Color(0xFFF1ECFF);
  static const blush = Color(0xFFFFF2F8);
  static const canvas = Color(0xFFFAF8FD);
  static const teal = Color(0xFF3EBFAD);
  static const gold = Color(0xFFF4BF4F);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.violet,
    brightness: Brightness.light,
    surface: Colors.white,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.canvas,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 26,
        height: 1.15,
        fontWeight: FontWeight.w800,
        color: AppColors.ink,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
      ),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4, color: AppColors.ink),
      bodySmall: TextStyle(fontSize: 12, height: 1.35, color: AppColors.muted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: const TextStyle(color: AppColors.muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFECE8F3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.violet, width: 1.5),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      margin: EdgeInsets.zero,
    ),
  );
}

class AppSpace {
  static const page = 22.0;
  static const card = 16.0;
  static const section = 25.0;
}

BoxDecoration softCard({Color? color, double radius = 22}) => BoxDecoration(
  color: color ?? Colors.white,
  borderRadius: BorderRadius.circular(radius),
  boxShadow: const [
    BoxShadow(color: Color(0x0D533A8A), blurRadius: 22, offset: Offset(0, 8)),
  ],
);
