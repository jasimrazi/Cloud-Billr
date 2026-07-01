import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData? leadingIcon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? iconColor;

  const SettingsTile({
    super.key,
    this.leadingIcon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultIconColor = iconColor ?? appColors.textSecondaryColor;
    final defaultTextColor = textColor ?? appColors.textColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (leadingIcon != null) ...[
                  Icon(leadingIcon, color: defaultIconColor, size: 22),
                  const SizedBox(width: AppSpacing.spacingM),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: defaultTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: EdgeInsets.only(
                  left: leadingIcon != null ? 38.0 : 0,
                ),
                child: Text(
                  subtitle!,
                  style: TextStyle(
                    color: appColors.textSecondaryColor.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
