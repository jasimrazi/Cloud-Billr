import 'package:cloud_billr/main.dart';
import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final Icon icon; 
  final String label;
  final Color color;
  const IconWidget({super.key,
  required this.color,
  required this.icon,
  required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: appColors.surfaceColor,
          child: Icon(icon.icon, color: color),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: appColors.textColor)),
      ],
    );
  }
}