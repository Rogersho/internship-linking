import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors - High contrast & High visibility
  static const Color primaryLight = Color(0xFF4F46E5); // Indigo 600
  static const Color primaryDark =
      Color(0xFF818CF8); // Indigo 400 (Vibrant for dark)
  static const Color accentColor = Color(0xFF10B981); // Emerald 500

  // Neutral Colors (Light)
  static const Color bgLight = Color(0xFFF1F5F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textLightPrimary = Color(0xFF0F172A);
  static const Color textLightSecondary = Color(0xFF64748B);

  // Neutral Colors (Dark)
  static const Color bgDark = Color(0xFF020617);
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color textDarkPrimary = Color(0xFFF8FAFC);
  static const Color textDarkSecondary = Color(0xFF94A3B8);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryLight,
      primary: primaryLight,
      secondary: accentColor,
      surface: surfaceLight,
      onSurface: textLightPrimary,
      onSurfaceVariant: textLightSecondary,
      brightness: Brightness.light,
    ),
    primaryColor: primaryLight,
    scaffoldBackgroundColor: bgLight,
    textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
      headlineMedium: GoogleFonts.plusJakartaSans(
          color: textLightPrimary, fontWeight: FontWeight.w800),
      bodyLarge: GoogleFonts.plusJakartaSans(color: textLightPrimary),
      bodyMedium: GoogleFonts.plusJakartaSans(color: textLightSecondary),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: bgLight,
      foregroundColor: textLightPrimary,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: textLightPrimary,
        letterSpacing: -0.5,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: textLightSecondary.withOpacity(0.1), width: 1),
      ),
      color: surfaceLight,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: textLightSecondary.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: textLightSecondary.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      labelStyle: const TextStyle(color: textLightSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceLight,
      indicatorColor: primaryLight.withOpacity(0.1),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: textLightPrimary),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primaryLight);
        }
        return const IconThemeData(color: textLightSecondary);
      }),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryDark,
      primary: primaryDark,
      secondary: accentColor,
      surface: surfaceDark,
      onSurface: textDarkPrimary,
      onSurfaceVariant: textDarkSecondary,
      surfaceContainerHighest: Color(0xFF1E293B), // Explicit surface variant
      surfaceContainer: Color(0xFF1E293B),
      brightness: Brightness.dark,
    ),
    primaryColor: primaryDark,
    scaffoldBackgroundColor: bgDark,
    textTheme: GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme)
        .copyWith(
      headlineMedium: GoogleFonts.plusJakartaSans(
          color: textDarkPrimary, fontWeight: FontWeight.w800),
      bodyLarge: GoogleFonts.plusJakartaSans(color: textDarkPrimary),
      bodyMedium: GoogleFonts.plusJakartaSans(color: textDarkSecondary),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: bgDark,
      foregroundColor: textDarkPrimary,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: textDarkPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      color: surfaceDark,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceDark,
      indicatorColor: primaryDark.withOpacity(0.15),
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: primaryDark);
        }
        return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textDarkSecondary);
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primaryDark, size: 24);
        }
        return const IconThemeData(color: textDarkSecondary, size: 24);
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor:
          const Color(0xFF1E293B), // Use a slightly lighter surface for inputs
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryDark, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      hintStyle: const TextStyle(color: textDarkSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: bgDark,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
