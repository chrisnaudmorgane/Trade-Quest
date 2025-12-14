import 'package:flutter/material.dart';

class AppColors {
  // From HTML Design
  static const Color primary = Color(0xFF0DA6F2); // #0da6f2
  static const Color backgroundDark = Color(0xFF101C22); // #101c22
  static const Color backgroundLight = Color(0xFFF5F7F8); // #f5f7f8
  static const Color cardDark = Color(0xFF182830); // #182830
  static const Color accentNeon = Color(0xFF0DA6F2); // #0da6f2
  
  // Shadows (Simulated with Colors for BoxShadow)
  static Color shadowNeon = const Color(0xFF0DA6F2).withOpacity(0.5);
  static Color shadowNeonStrong = const Color(0xFF0DA6F2).withOpacity(0.6);
  static Color shadowGold = const Color(0xFFFFD700).withOpacity(0.4);

  // Legacy/Fallbacks (kept for compatibility or mapped)
  static const Color neonBlue = primary;
  static const Color neonPurple = Color(0xFFBC13FE); 
  static const Color neonGreen = Color(0xFF34A853); // Google Green
  static const Color neonRed = Color(0xFFEA4335); // Google Red
  static const Color background = backgroundDark;
  static const Color surface = cardDark;
  static const Color surfaceGlass = Color(0xCC182830);
  
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8); // Slate 400

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
}
