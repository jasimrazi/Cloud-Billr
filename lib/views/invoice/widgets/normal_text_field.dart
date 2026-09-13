import 'package:cloud_billr/helpers/responsive.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class NormalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int lineCount;
  const NormalTextField({super.key,
  required this.controller,
  required this.hintText,
  this.lineCount = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: lineCount,
      decoration: InputDecoration(
        fillColor: appColors.cardBackgroundColor,
        filled: true,
        contentPadding: EdgeInsets.all(AppSpacing.textFieldPadding),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(AppRadius.medium)
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: appColors.hintTextColor,
          fontWeight: FontWeight.w400,
          fontSize: Responsive.font(16)
        )
      ),
    );
  }
}