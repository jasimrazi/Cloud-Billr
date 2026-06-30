import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class TotalsSection extends StatelessWidget {
  const TotalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingMedium),
      decoration: BoxDecoration(
        color: appColors.surfaceColor,
        borderRadius: AppRadius.medium,
        border: Border.all(color: appColors.borderColor),
      ),
      child: Column(
        children: [
          _buildRow('Subtotal', '\$0.00'),
          const SizedBox(height: AppSpacing.spacingM),
          _buildRow('Tax Amount', '\$0.00'),
          const SizedBox(height: AppSpacing.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount',
                style: TextStyle(
                  color: appColors.textSecondaryColor,
                  fontSize: 14,
                ),
              ),
              Container(
                width: 80,
                height: 36,
                decoration: BoxDecoration(
                  color: appColors.backgroundColor,
                  borderRadius: AppRadius.medium,
                  border: Border.all(color: appColors.borderColor),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: appColors.textColor,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: appColors.textSecondaryColor.withOpacity(0.5),
                    ),
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingM),
          Divider(color: appColors.borderColor, thickness: 1),
          const SizedBox(height: AppSpacing.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  color: appColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$0.00',
                style: TextStyle(
                  color: appColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: appColors.textSecondaryColor,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
