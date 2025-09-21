import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;
  const InvoiceCard({super.key,
  required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.paddingMedium),
      margin: EdgeInsets.only(bottom: AppSpacing.marginMedium),
      decoration: BoxDecoration(
        borderRadius: AppRadius.medium,
        border: Border.all(color: appColors.borderColor)
      ),
      child: Column(
        spacing: AppSpacing.spacingS,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(invoice.invoiceNumber, style: TextStyle(
                      color: appColors.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14
                    ),),
                
                    Text(invoice.clientName,style: TextStyle(
                      color: appColors.textSecondaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14
                    ),),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.paddingSmall),
                decoration: BoxDecoration(
                  color: getStatusContainerColor(status: invoice.status.toLowerCase()),
                  borderRadius: AppRadius.medium
                ),child: Text(invoice.status, style: TextStyle(
                  color: getStatusTextColor(status: invoice.status.toLowerCase())
                ),),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(invoice.amount, style: TextStyle(
                  color: appColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),),
              ),
              Text(invoice.date, style: TextStyle(
                color: appColors.textSecondaryColor,
                fontWeight: FontWeight.w400,
                fontSize: 12

              ),)
            ],
          )
        ],
      ),
    );
  }

  Color getStatusContainerColor({
    required String status
  }){
    switch(status){
      case 'pending': 
        return appColors.pendingYellowBgColor;
      case 'paid':
        return appColors.successGreenBgColor;
      default :
        return Colors.white;
    }
  }

  Color getStatusTextColor({
    required String status
  }){
    switch(status){
      case 'pending': 
        return appColors.pendingYellowColor;
      case 'paid':
        return appColors.successGreenColor;
      default :
        return appColors.textColor;
    }
  }
}