
import 'package:flutter/material.dart';

import '../helpers/responsive.dart';

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

