import 'package:cloud_billr/main.dart';
import 'package:flutter/material.dart';

import '../utils/theme.dart';

class AppButton extends StatelessWidget {
  final String buttonLabel;
  final  VoidCallback onTap;
  const AppButton({super.key,
  required this.buttonLabel,
  required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: AppSpacing.buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: appColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(
          buttonLabel,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}