import 'dart:io';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class LogoPicker extends StatelessWidget {
  final String? logoPath;
  final VoidCallback? onTap;

  const LogoPicker({
    super.key,
    this.logoPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (logoPath == null || logoPath!.isEmpty) {
      // Placeholder
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 32,
            color: appColors.textSecondaryColor.withValues(alpha: 0.6),
          ),
          SizedBox(height: AppSpacing.spacingS),
          Text(
            'Add Logo',
            style: TextStyle(
              color: appColors.textSecondaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else if (logoPath!.startsWith('preset:')) {
      // Parse preset:icon_name:color_hex
      final parts = logoPath!.split(':');
      final iconName = parts.length > 1 ? parts[1] : 'business';
      final colorHex = parts.length > 2 ? parts[2] : '0xFF2196F3';
      
      final color = Color(int.parse(colorHex));
      IconData iconData;
      switch (iconName) {
        case 'store':
          iconData = Icons.store;
          break;
        case 'computer':
          iconData = Icons.computer;
          break;
        case 'build':
          iconData = Icons.build;
          break;
        case 'shopping_bag':
          iconData = Icons.shopping_bag;
          break;
        case 'account_balance':
          iconData = Icons.account_balance;
          break;
        case 'spa':
          iconData = Icons.spa;
          break;
        case 'restaurant':
          iconData = Icons.restaurant;
          break;
        case 'flash_on':
          iconData = Icons.flash_on;
          break;
        case 'star':
          iconData = Icons.star;
          break;
        case 'palette':
          iconData = Icons.palette;
          break;
        case 'attach_money':
          iconData = Icons.attach_money;
          break;
        case 'business':
        default:
          iconData = Icons.business;
          break;
      }

      content = Center(
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(
            iconData,
            size: 36,
            color: color,
          ),
        ),
      );
    } else {
      // File image
      content = ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.large),
        child: Image.file(
          File(logoPath!),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.broken_image, color: appColors.redColor);
          },
        ),
      );
    }

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: appColors.surfaceColor,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(color: appColors.borderColor),
          ),
          child: content,
        ),
      ),
    );
  }
}
