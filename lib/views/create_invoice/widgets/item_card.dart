import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/create_invoice/widgets/labeled_text_field.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final int index;
  final VoidCallback? onRemove;

  const ItemCard({
    super.key,
    required this.index,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingMedium),
      margin: const EdgeInsets.only(bottom: AppSpacing.marginMedium),
      decoration: BoxDecoration(
        color: appColors.backgroundColor,
        borderRadius: AppRadius.medium,
        border: Border.all(color: appColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item Details',
                style: TextStyle(
                  color: appColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.delete_outline,
                    color: appColors.textSecondaryColor.withValues(alpha: 0.8),
                  ),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingM),
          const LabeledTextField(
            hintText: 'Item name',
          ),
          const SizedBox(height: AppSpacing.spacingM),
          Row(
            children: [
              const Expanded(
                child: LabeledTextField(
                  hintText: 'Quantity',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: AppSpacing.spacingM),
              const Expanded(
                child: LabeledTextField(
                  hintText: 'Rate',
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingM),
          const LabeledTextField(
            hintText: 'Tax (%)',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
    );
  }
}
