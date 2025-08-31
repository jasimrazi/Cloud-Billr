
import 'package:flutter/material.dart';

class AppColors{

  static const primaryColorLight = Color(0xFF2196F3);
  static const primaryColorDark = Color(0xFF2196F3);
  static const secondaryColorLight = Color(0xFFF9FAFB);
  static const secondaryColorDark = Color(0xFFD1D5DB);

  static const lightBackground = Color(0xFFFFFFFF);
  static const darkBackground = Color(0xFF111827);
  static const lightSurfaceColor = Color(0xFFF8F9FA);
  static const darkSurfaceColor = Color(0xFF1F2937);

  static const lightTextColor = Color(0xFF000000);
  static const lightTextSecondaryColor = Color(0xFF4B5563);
  static const darkTextColor = Color(0xFFFFFFFF);

  // Success Green
  static const successGreenLight = Color(0xFF049668);
  static const successGreenDark = Color(0xFF4ADE80);
  static const successGreenBgLight = Color(0xFFECFDF5);
  static const successGreenBgDark = Color(0xFF052E16);

  // Warning Yellow
  static const pendingYellowTextLight = Color(0xFFD97706);
  static const pendingYellowTextDark = Color(0xFFFDE047);
  static const pendigYellowBgLight = Color(0xFFFFFBEB);
  static const pendingYellowBgDark = Color(0xFF3F3F06);

  static const primaryBlueBgLight = Color(0xFFE3F3FC);
  static const primaryBlueBgDark = Color(0xFF1E3A8A);

  // Violet
  static const violetLight = Color(0xFFAF66EE);
  static const violetDark = Color(0xFFA78BFA);

  // red
  static const redLight = Color(0xFFE14646);

  //border colors
  static const borderColorLight = Color(0xFFF3F4F6);
  static const borderColorDark = Color(0xFF374151);
}

class AppSpacing {
  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Margin
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;

  // Spacing between widgets
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;

  // Heights for common widgets
  static const double buttonHeight = 48.0;
  static const double textFieldHeight = 56.0;
  static const double appBarHeight = kToolbarHeight; // Flutter default = 56
}

class AppRadius {
  // Small rounded corners
  static const BorderRadius small = BorderRadius.all(Radius.circular(4));

  // Medium rounded corners (common for cards, containers)
  static const BorderRadius medium = BorderRadius.all(Radius.circular(8));

  // Large rounded corners (buttons, modals)
  static const BorderRadius large = BorderRadius.all(Radius.circular(16));

  // Extra large (bottom sheets, big containers)
  static const BorderRadius extraLarge = BorderRadius.all(Radius.circular(24));

  // Full circle (avatars, chips, round buttons)
  static const BorderRadius circle = BorderRadius.all(Radius.circular(9999));
}

