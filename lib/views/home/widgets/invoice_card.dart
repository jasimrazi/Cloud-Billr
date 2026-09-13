import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/invoices/invoice_detail_screen.dart';
import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  const InvoiceCard({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InvoiceDetailScreen(invoice: invoice),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.paddingMedium),
        margin: EdgeInsets.only(bottom: AppSpacing.marginMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: appColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.invoiceNumber,
                        style: TextStyle(
                          color: appColors.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        invoice.clientName,
                        style: TextStyle(
                          color: appColors.textSecondaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingSmall, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statusBgColor(invoice.status.toLowerCase()),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Text(
                    invoice.status,
                    style: TextStyle(
                      color: _statusTextColor(invoice.status.toLowerCase()),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.spacingS),
            Row(
              children: [
                Expanded(
                  child: Text(
                    invoice.amount,
                    style: TextStyle(
                      color: appColors.textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  invoice.date,
                  style: TextStyle(
                    color: appColors.textSecondaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'pending':
        return appColors.pendingYellowBgColor;
      case 'paid':
        return appColors.successGreenBgColor;
      case 'overdue':
        return const Color(0xFFFFE4E6);
      default:
        return appColors.borderColor;
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'pending':
        return appColors.pendingYellowColor;
      case 'paid':
        return appColors.successGreenColor;
      case 'overdue':
        return const Color(0xFFDC2626);
      default:
        return appColors.textColor;
    }
  }
}