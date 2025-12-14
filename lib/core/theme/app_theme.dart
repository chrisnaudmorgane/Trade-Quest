import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primary,
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.cardDark,
        onSurface: AppColors.textPrimary,
        background: AppColors.backgroundDark,
      ),

      textTheme: TextTheme(
        // Font Family: Space Grotesk (Display)
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 48, // text-5xl
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 36, // text-4xl
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        
        // Font Family: Noto Sans (Body)
        bodyLarge: GoogleFonts.notoSans(
          fontSize: 18, // text-lg
          color: AppColors.textSecondary,
          height: 1.6, // leading-relaxed
        ),
        bodyMedium: GoogleFonts.notoSans(
          fontSize: 16, // text-base
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0F172A), // Slate 900 for button text
        ),
        labelSmall: GoogleFonts.notoSans( // For footer text
          fontSize: 10,
          color: const Color(0xFF475569), // Slate 600
        ),
      ),
    );
  }
}
