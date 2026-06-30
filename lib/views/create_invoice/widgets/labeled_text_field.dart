import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final String? label;
  final String hintText;
  final int maxLines;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  const LabeledTextField({
    super.key,
    this.label,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: appColors.textColor.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.spacingS),
        ],
        Container(
          decoration: BoxDecoration(
            color: appColors.surfaceColor,
            borderRadius: AppRadius.medium,
            border: Border.all(color: appColors.borderColor),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: TextStyle(color: appColors.textColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: appColors.textSecondaryColor.withValues(alpha: 0.5),
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingMedium,
                vertical: 12,
              ),
              border: InputBorder.none,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
