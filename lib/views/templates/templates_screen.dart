import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  int _selectedTemplateIndex = 0;

  final List<Map<String, dynamic>> _templates = [
    {
      'name': 'Classic Professional',
      'desc': 'Structured invoice layout with solid headers, clean borders, and formal styling.',
      'color': const Color(0xFF2196F3),
    },
    {
      'name': 'Minimalist Clean',
      'desc': 'Clean, lightweight design with lots of whitespace, perfect for modern freelancers.',
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'Creative Studio',
      'desc': 'Vibrant accents, modern type scale, and playful details suitable for studios.',
      'color': const Color(0xFFAF66EE),
    },
    {
      'name': 'Bold Corporate',
      'desc': 'Strong vertical layout, dark header blocks, and emphasized client information.',
      'color': const Color(0xFF1F2937),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appColors.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Invoice Templates',
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.mainPadding),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.spacingM,
            crossAxisSpacing: AppSpacing.spacingM,
            childAspectRatio: 0.72,
          ),
          itemCount: _templates.length,
          itemBuilder: (context, index) {
            final template = _templates[index];
            final isSelected = _selectedTemplateIndex == index;
            final primaryAccent = template['color'] as Color;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTemplateIndex = index;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${template['name']} set as default template!'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.surfaceColor,
                  borderRadius: AppRadius.medium,
                  border: Border.all(
                    color: isSelected ? appColors.primaryColor : appColors.borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Visual Preview card Representation
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(AppSpacing.paddingSmall),
                        decoration: BoxDecoration(
                          color: appColors.backgroundColor,
                          borderRadius: AppRadius.medium,
                          border: Border.all(color: appColors.borderColor),
                        ),
                        child: Stack(
                          children: [
                            // Fake Invoice lines representing the template style
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 8,
                                    width: 40,
                                    color: primaryAccent,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(height: 6, width: 30, color: appColors.borderColor),
                                      Container(height: 6, width: 20, color: appColors.borderColor),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Container(height: 4, width: 50, color: appColors.borderColor),
                                  const Spacer(),
                                  Divider(color: appColors.borderColor, thickness: 1, height: 1),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(height: 6, width: 25, color: appColors.borderColor),
                                      Container(height: 6, width: 25, color: primaryAccent),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: appColors.primaryColor,
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppSpacing.paddingSmall,
                        right: AppSpacing.paddingSmall,
                        bottom: AppSpacing.paddingSmall,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: appColors.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            template['desc'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: appColors.textSecondaryColor,
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
