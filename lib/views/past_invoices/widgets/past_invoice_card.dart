import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/invoices/invoice_detail_screen.dart';
import 'package:flutter/material.dart';

class PastInvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;

  const PastInvoiceCard({super.key, required this.invoice});

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
          color: appColors.backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: appColors.borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice.invoiceNumber,
                    style: TextStyle(
                      color: appColors.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    invoice.clientName,
                    style: TextStyle(
                      color: appColors.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    invoice.date,
                    style: TextStyle(
                      color:
                          appColors.textSecondaryColor.withValues(alpha: 0.7),
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
                  invoice.amount,
                  style: TextStyle(
                    color: appColors.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusBgColor(invoice.status.toLowerCase()),
                    borderRadius: AppRadius.circle,
                  ),
                  child: Text(
                    invoice.status,
                    style: TextStyle(
                      color: _statusTextColor(invoice.status.toLowerCase()),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
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
