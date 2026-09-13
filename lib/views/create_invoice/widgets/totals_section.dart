import 'package:cloud_billr/controllers/create_invoice_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TotalsSection extends StatelessWidget {
  const TotalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateInvoiceProvider>(
      builder: (context, provider, _) {
        final symbol = provider.currencySymbol;
        final subtotal = provider.subtotal;
        final taxAmt = provider.taxAmount;
        final grand = provider.grandTotal;

        return Container(
          padding: EdgeInsets.all(AppSpacing.paddingMedium),
          decoration: BoxDecoration(
            color: appColors.surfaceColor,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: appColors.borderColor),
          ),
          child: Column(
            children: [
              _buildRow('Subtotal', '$symbol${subtotal.toStringAsFixed(2)}'),
              if (provider.taxEnabled) ...[
                SizedBox(height: AppSpacing.spacingM),
                _buildRow(
                  '${provider.taxLabel} (${provider.taxRate.toStringAsFixed(0)}%)'
                  '${provider.taxIsInclusive ? ' – incl.' : ''}',
                  '$symbol${taxAmt.toStringAsFixed(2)}',
                ),
              ],
              if (provider.discountEnabled) ...[
                SizedBox(height: AppSpacing.spacingM),
                _buildDiscountRow(context, provider, symbol),
              ],
              SizedBox(height: AppSpacing.spacingM),
              Divider(color: appColors.borderColor, thickness: 1),
              SizedBox(height: AppSpacing.spacingM),
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
                    '$symbol${grand.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: appColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: appColors.textSecondaryColor, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
              color: appColors.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDiscountRow(
    BuildContext context,
    CreateInvoiceProvider provider,
    String symbol,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          provider.discountType == 'percentage'
              ? 'Discount (%)'
              : 'Discount ($symbol)',
          style: TextStyle(color: appColors.textSecondaryColor, fontSize: 14),
        ),
        Row(
          children: [
            Text(
              '- $symbol${provider.discountAmount.toStringAsFixed(2)}',
              style: TextStyle(
                color: appColors.redColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 72,
              height: 32,
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.backgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(color: appColors.borderColor),
                ),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  style: TextStyle(color: appColors.textColor, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: appColors.textSecondaryColor.withValues(alpha: 0.5),
                    ),
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                  onChanged: (val) {
                    final v = double.tryParse(val) ?? 0;
                    provider.setDiscount(v);
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
