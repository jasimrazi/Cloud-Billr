
import 'package:flutter/material.dart';

class AppSpacing {
  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double mainPadding = 20;

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

