import 'package:flutter/material.dart';

/// App-wide color constants
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF8B0000);
  static const Color primaryLight = Color(0xFFB22222);
  static const Color primaryDark = Color(0xFF5C0000);

  // Secondary Colors
  static const Color secondary = Color(0xFFE53935);
  static const Color accent = Color(0xFFFF5252);

  // Neutral Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyDark = Color(0xFF616161);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Blood Type Colors
  static const Color bloodTypeA = Color(0xFFE53935);
  static const Color bloodTypeB = Color(0xFF1E88E5);
  static const Color bloodTypeAB = Color(0xFF8E24AA);
  static const Color bloodTypeO = Color(0xFF43A047);
  
  // Blood Type Color Aliases
  static const Color bloodA = bloodTypeA;
  static const Color bloodB = bloodTypeB;
  static const Color bloodAB = bloodTypeAB;
  static const Color bloodO = bloodTypeO;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
