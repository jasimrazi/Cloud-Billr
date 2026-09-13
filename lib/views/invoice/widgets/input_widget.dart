import 'package:cloud_billr/helpers/responsive.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String label;
  final Widget textField;
  const InputWidget({super.key,
  required this.label,
  required this.textField});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Responsive.height(4),
      children: [
        Text(label, style: TextStyle(
          color: appColors.labelTextColor,
          fontSize: AppFontsSizes.fontSizeM,
          fontWeight: FontWeight.w400,
        ),),
        textField
      ],
    );
  }
}