import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class LogoPicker extends StatelessWidget {
  final VoidCallback? onTap;

  const LogoPicker({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: appColors.surfaceColor,
            borderRadius: AppRadius.large,
            border: Border.all(color: appColors.borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 32,
                color: appColors.textSecondaryColor.withValues(alpha: 0.6),
              ),
              const SizedBox(height: AppSpacing.spacingS),
              Text(
                'Add Logo',
                style: TextStyle(
                  color: appColors.textSecondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
