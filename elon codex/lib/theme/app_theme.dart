import 'package:farms_gate_marketplace/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF5EC052));

class AppTheme {
  static final ThemeData lightTheme = ThemeData().copyWith(
    useMaterial3: true,
    colorScheme: kColorScheme,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
        labelSmall: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            // letterSpacing: -1,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF248D0E)),
        headlineLarge: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            letterSpacing: -1,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF248D0E)),
        headlineMedium: GoogleFonts.plusJakartaSans(
            fontSize: 22, fontWeight: FontWeight.w500, color: Colors.black),
        headlineSmall: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            // fontWeight: FontWeight.w500,
            color: AppColors.textPrimary),
        bodyLarge: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.plusJakartaSans(
            fontSize: 14, color: AppColors.textSecondary),
        bodySmall: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary),
        labelLarge: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
        labelMedium: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.textPrimary),
        titleMedium: GoogleFonts.plusJakartaSans(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        titleSmall: GoogleFonts.plusJakartaSans(
            fontSize: 10, fontWeight: FontWeight.w500, color: Colors.black)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        shadowColor: Colors.transparent,
        elevation: 0,
        disabledBackgroundColor: Colors.green.shade200,
        enableFeedback: true,
        backgroundColor: AppColors.primary,
        textStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.5),
        ),
      ),
    ),
    dialogBackgroundColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      alignLabelWithHint: true,
      contentPadding: const EdgeInsets.only(left: 10),
      filled: true,
      fillColor: AppColors.surface,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey.shade500, width: 1),
      ),
      outlineBorder: BorderSide(
        color: Colors.grey.shade300,
        width: 1,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.primary, width: 1),
      ),
      hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14,
          fontStyle: GoogleFonts.plusJakartaSans().fontStyle),
    ),
    appBarTheme: const AppBarTheme(
      toolbarHeight: 128,
      color: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
