
import 'package:flutter/material.dart';

import '../helpers/responsive.dart';
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

  static const shadowColorLight = Color(0x0D000000);
}

class AppSpacing {
  // Padding
  static double paddingSmall = Responsive.width(8);
  static double paddingMedium = Responsive.width(16);
  static double paddingLarge = Responsive.width(24);
  static double mainPadding = Responsive.width(20);

  static double textFieldPadding = Responsive.width(12);

  // Margin
  static double marginSmall = Responsive.width(8);
  static double marginMedium = Responsive.width(16);
  static double marginLarge = Responsive.width(24);

  // Spacing between widgets
  static double spacingXS = Responsive.width(4);
  static double spacingS = Responsive.width(8);
  static double spacingM = Responsive.width(16);
  static double spacingL = Responsive.width(20);
  static double spacingXL = Responsive.width(32);

}

class AppHeights{

  static double appBarHeight = Responsive.height(60); 
  static double appBarIconHeight = Responsive.height(24);
  static double buttonHeight = Responsive.width(48);
  static double textFieldHeight = Responsive.width(56);
}

class AppWidths{

  static double appBarIconWidth = Responsive.width(24);
}

class AppRadius {
  // Small rounded corners
  static double small = Responsive.width(4);
  static double medium = Responsive.width(8);
  static double large = Responsive.width(16);
  static double extraLarge = Responsive.width(24);

  // Full circle (avatars, chips, round buttons)
  static BorderRadius circle = BorderRadius.all(Radius.circular(Responsive.width(9999)));
}

class AppFontsSizes{

  static double fontSizeS = Responsive.font(12);
  static double fontSizeM = Responsive.font(14);
  static double fontSizeL = Responsive.font(20);

  static double appBarTitleSize = Responsive.font(18);
}

