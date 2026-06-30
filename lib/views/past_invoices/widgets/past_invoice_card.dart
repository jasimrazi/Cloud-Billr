import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class PastInvoiceCard extends StatelessWidget {
  final String title;
  final String clientName;
  final String date;
  final String amount;
  final VoidCallback? onPdfTap;

  const PastInvoiceCard({
    super.key,
    required this.title,
    required this.clientName,
    required this.date,
    required this.amount,
    this.onPdfTap,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: appColors.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  clientName,
                  style: TextStyle(
                    color: appColors.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: appColors.textSecondaryColor.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: appColors.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: AppSpacing.spacingS),
              GestureDetector(
                onTap: onPdfTap,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: appColors.primaryBlueColor.withOpacity(0.5),
                  child: Icon(
                    Icons.description_outlined,
                    size: 18,
                    color: appColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
