import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class TemplatePicker extends StatefulWidget {
  const TemplatePicker({super.key});

  @override
  State<TemplatePicker> createState() => _TemplatePickerState();
}

class _TemplatePickerState extends State<TemplatePicker> {
  int _selectedTemplateIndex = 0;

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: AppSpacing.spacingM),
        SizedBox(
          height: 120,
          child: Row(
            children: List.generate(3, (index) {
              final isSelected = _selectedTemplateIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTemplateIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index == 2 ? 0 : AppSpacing.spacingM,
                    ),
                    decoration: BoxDecoration(
                      color: appColors.surfaceColor,
                      borderRadius: AppRadius.medium,
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
                            color: isSelected
                                ? appColors.primaryColor
                                : appColors.textSecondaryColor.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: AppSpacing.spacingS),
                          Text(
                            'Template ${index + 1}',
                            style: TextStyle(
                              color: isSelected
                                  ? appColors.primaryColor
                                  : appColors.textSecondaryColor,
                              fontSize: 12,
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
  }
}
