import 'dart:ui';

class AppColorScheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final Color textSecondaryColor;
  final Color successGreenColor;
  final Color successGreenBgColor;
  final Color pendingYellowColor;
  final Color pendingYellowBgColor;
  final Color primaryBlueColor;
  final Color violetColor;
  final Color redColor;
  final Color borderColor;
  final Color shadowColor;
  final Color cardBackgroundColor;
  final Color cardTextColor;
  final Color hintTextColor;
  final Color labelTextColor;

  const AppColorScheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textColor,
    required this.textSecondaryColor,
    required this.successGreenColor,
    required this.successGreenBgColor,
    required this.pendingYellowColor,
    required this.pendingYellowBgColor,
    required this.primaryBlueColor,
    required this.violetColor,
    required this.redColor,
    required this.borderColor,
    required this.shadowColor,
    required this.cardBackgroundColor,
    required this.cardTextColor,
    required this.hintTextColor,
    required this.labelTextColor
  });

  // ✅ Light Scheme
  static const AppColorScheme light = AppColorScheme(
    primaryColor: Color(0xFF2196F3),
    secondaryColor: Color(0xFFF9FAFB),
    backgroundColor: Color(0xFFFFFFFF),
    surfaceColor: Color(0xFFF8F9FA),
    textColor: Color(0xFF000000),
    textSecondaryColor: Color(0xFF4B5563),
    successGreenColor: Color(0xFF049668),
    successGreenBgColor: Color(0xFFECFDF5),
    pendingYellowColor: Color(0xFFD97706),
    pendingYellowBgColor: Color(0xFFFFFBEB),
    primaryBlueColor: Color(0xFFE3F3FC),
    violetColor: Color(0xFFAF66EE),
    redColor: Color(0xFFE14646),
    borderColor: Color(0xFFF3F4F6),
    shadowColor: Color(0x0D000000),
    cardBackgroundColor: Color(0xFFF3F4F6),
    cardTextColor: Color(0xFF4B5563),
    hintTextColor: Color(0xFF9CA3AF),
    labelTextColor: Color(0xFF4B5563),
  );

  // ✅ Dark Scheme
  static const AppColorScheme dark = AppColorScheme(
    primaryColor: Color(0xFF2196F3),
    secondaryColor: Color(0xFF1E1E1E),
    backgroundColor: Color(0xFF121212),
    surfaceColor: Color(0xFF1E1E1E),
    textColor: Color(0xFFFFFFFF),
    textSecondaryColor: Color(0xFF9CA3AF),
    successGreenColor: Color(0xFF4ADE80),
    successGreenBgColor: Color(0xFF052E16),
    pendingYellowColor: Color(0xFFFDE047),
    pendingYellowBgColor: Color(0xFF3F3F06),
    primaryBlueColor: Color(0xFF1E3A8A),
    violetColor: Color(0xFFA78BFA),
    redColor: Color(0xFFEF5350 ),
    borderColor: Color(0xFF374151),
    shadowColor: Color(0x1AFFFFFF),
    cardBackgroundColor: Color(0xFF1E1F24),
    cardTextColor: Color(0xFF9CA3AF),
    hintTextColor: Color(0xFFD1D5DB),
    labelTextColor: Color(0xFF9CA3AF)
  );
}
