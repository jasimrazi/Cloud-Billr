import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/controllers/invoice_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  int _selectedTemplateIndex = 0;

  @override
  void initState() {
    super.initState();
    final configProvider = Provider.of<InvoiceConfigProvider>(context, listen: false);
    _selectedTemplateIndex = configProvider.config.defaultTemplateIndex;
  }

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
          padding: EdgeInsets.all(AppSpacing.mainPadding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
              onTap: () async {
                setState(() {
                  _selectedTemplateIndex = index;
                });
                final messenger = ScaffoldMessenger.of(context);
                final configProvider = Provider.of<InvoiceConfigProvider>(context, listen: false);
                await configProvider.saveConfig(configProvider.config.copyWith(defaultTemplateIndex: index));
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('${template['name']} set as default template!'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.surfaceColor,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
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
                        margin: EdgeInsets.all(AppSpacing.paddingSmall),
                        decoration: BoxDecoration(
                          color: appColors.backgroundColor,
                          borderRadius: BorderRadius.circular(AppRadius.medium),
                          border: Border.all(color: appColors.borderColor),
                        ),
                        child: Stack(
                          children: [
                             _buildTemplatePreview(index, primaryAccent),
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
                      padding: EdgeInsets.only(
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

  Widget _buildTemplatePreview(int index, Color accent) {
    switch (index) {
      case 1: // Minimalist Clean
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 10, width: 35, color: Colors.grey.shade400),
                  Container(height: 6, width: 20, color: Colors.grey.shade300),
                ],
              ),
              const SizedBox(height: 10),
              Container(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 5, width: 25, color: Colors.grey.shade300),
                  Container(height: 5, width: 25, color: Colors.grey.shade300),
                ],
              ),
              const Spacer(),
              Container(height: 5, width: 50, color: Colors.grey.shade200),
              const SizedBox(height: 2),
              Container(height: 5, width: 50, color: Colors.grey.shade200),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Container(height: 10, width: 30, color: Colors.grey.shade500),
              ),
            ],
          ),
        );
      case 2: // Creative Studio
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 5, width: 40, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Container(height: 4, width: 30, color: Colors.grey.shade300),
                    Container(height: 4, width: 25, color: Colors.grey.shade200),
                    const SizedBox(height: 8),
                    Container(height: 4, width: 30, color: Colors.grey.shade300),
                    Container(height: 4, width: 25, color: Colors.grey.shade200),
                    const Spacer(),
                    Container(height: 6, width: 45, color: Colors.grey.shade300),
                    const SizedBox(height: 2),
                    Container(height: 6, width: 45, color: Colors.grey.shade200),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(height: 10, width: 25, color: Colors.grey.shade500),
                    const SizedBox(height: 4),
                    Container(height: 4, width: 20, color: Colors.grey.shade300),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.grey.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(height: 3, width: 15, color: Colors.grey.shade400),
                          const SizedBox(height: 2),
                          Container(height: 6, width: 20, color: Colors.grey.shade600),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case 3: // Bold Corporate
        return Column(
          children: [
            Container(
              color: Colors.grey.shade800,
              width: double.infinity,
              padding: const EdgeInsets.all(6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 6, width: 35, color: Colors.white),
                  Container(height: 8, width: 20, color: Colors.grey.shade200),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(height: 4, width: 25, color: Colors.grey.shade400),
                        Container(height: 4, width: 20, color: Colors.grey.shade400),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 8,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 2),
                    Container(height: 5, width: double.infinity, color: Colors.grey.shade100),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        color: Colors.grey.shade200,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(height: 4, width: 15, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Container(height: 6, width: 20, color: Colors.grey.shade700),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case 0: // Classic Professional
      default:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 10, width: 40, color: Colors.grey.shade500),
                  Container(height: 14, width: 25, color: Colors.grey.shade600),
                ],
              ),
              const SizedBox(height: 6),
              Container(height: 1.5, color: Colors.grey.shade400),
              const SizedBox(height: 6),
              Container(height: 4, width: 20, color: Colors.grey.shade400),
              const SizedBox(height: 2),
              Container(height: 4, width: 35, color: Colors.grey.shade300),
              const Spacer(),
              Container(height: 1, color: Colors.grey.shade300),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 4, width: 30, color: Colors.grey.shade300),
                  Container(height: 4, width: 30, color: Colors.grey.shade500),
                ],
              ),
            ],
          ),
        );
    }
  }
}
