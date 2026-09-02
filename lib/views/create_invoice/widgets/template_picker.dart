import 'package:cloud_billr/controllers/create_invoice_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemplatePicker extends StatelessWidget {
  const TemplatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateInvoiceProvider>(
      builder: (context, provider, _) {
        final selectedIndex = provider.selectedTemplateIndex;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Template',
              style: TextStyle(
                color: appColors.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.spacingM),
            SizedBox(
              height: 100,
              child: Row(
                children: List.generate(4, (index) {
                  final isSelected = selectedIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        provider.setSelectedTemplateIndex(index);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index == 3 ? 0 : AppSpacing.spacingS,
                        ),
                        decoration: BoxDecoration(
                          color: appColors.surfaceColor,
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          border: Border.all(
                            color: isSelected
                                ? appColors.primaryColor
                                : appColors.borderColor,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 20,
                                color: isSelected
                                    ? appColors.primaryColor
                                    : appColors.textSecondaryColor
                                        .withValues(alpha: 0.5),
                              ),
                              SizedBox(height: AppSpacing.spacingXS),
                              Text(
                                _templateName(index),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected
                                      ? appColors.primaryColor
                                      : appColors.textSecondaryColor,
                                  fontSize: 10,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  String _templateName(int index) {
    switch (index) {
      case 0:
        return 'Classic';
      case 1:
        return 'Minimal';
      case 2:
        return 'Creative';
      case 3:
        return 'Corporate';
      default:
        return 'Classic';
    }
  }
}
