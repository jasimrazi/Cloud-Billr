import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/company_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/create_invoice/widgets/labeled_text_field.dart';
import 'package:cloud_billr/views/create_invoice/widgets/logo_picker.dart';
import 'package:flutter/material.dart';

class AddEditCompanyScreen extends StatefulWidget {
  final CompanyModel? company;

  const AddEditCompanyScreen({super.key, this.company});

  @override
  State<AddEditCompanyScreen> createState() => _AddEditCompanyScreenState();
}

class _AddEditCompanyScreenState extends State<AddEditCompanyScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  String? _logoPath;

  @override
  void initState() {
    super.initState();
    if (widget.company != null) {
      _nameController.text = widget.company!.name;
      _addressController.text = widget.company!.address;
      _contactController.text = widget.company!.contactDetails;
      _logoPath = widget.company!.logoPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _showLogoPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: appColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            String selectedIcon = 'business';
            String selectedColorHex = '0xFF2196F3';
            if (_logoPath != null && _logoPath!.startsWith('preset:')) {
              final parts = _logoPath!.split(':');
              if (parts.length > 1) selectedIcon = parts[1];
              if (parts.length > 2) selectedColorHex = parts[2];
            }

            final presets = [
              {'name': 'business', 'icon': Icons.business},
              {'name': 'store', 'icon': Icons.store},
              {'name': 'computer', 'icon': Icons.computer},
              {'name': 'build', 'icon': Icons.build},
              {'name': 'shopping_bag', 'icon': Icons.shopping_bag},
              {'name': 'account_balance', 'icon': Icons.account_balance},
              {'name': 'spa', 'icon': Icons.spa},
              {'name': 'restaurant', 'icon': Icons.restaurant},
              {'name': 'flash_on', 'icon': Icons.flash_on},
              {'name': 'star', 'icon': Icons.star},
              {'name': 'palette', 'icon': Icons.palette},
              {'name': 'attach_money', 'icon': Icons.attach_money},
            ];

            final colors = [
              {'name': 'Blue', 'hex': '0xFF2196F3'},
              {'name': 'Violet', 'hex': '0xFFAF66EE'},
              {'name': 'Green', 'hex': '0xFF049668'},
              {'name': 'Yellow', 'hex': '0xFFD97706'},
              {'name': 'Red', 'hex': '0xFFE14646'},
              {'name': 'Grey', 'hex': '0xFF4B5563'},
              {'name': 'Orange', 'hex': '0xFFFF9800'},
              {'name': 'Teal', 'hex': '0xFF009688'},
            ];

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.mainPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Branding Logo Builder',
                          style: TextStyle(
                            color: appColors.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: appColors.textColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.spacingM),
                    Text(
                      'Choose Branding Color',
                      style: TextStyle(
                        color: appColors.textSecondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacingS),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: colors.length,
                        itemBuilder: (context, idx) {
                          final colorMap = colors[idx];
                          final hex = colorMap['hex']!;
                          final isSel = selectedColorHex == hex;
                          final color = Color(int.parse(hex));

                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedColorHex = hex;
                              });
                              setState(() {
                                _logoPath = 'preset:$selectedIcon:$selectedColorHex';
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSel
                                    ? Border.all(color: appColors.textColor, width: 2.5)
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacingM),
                    Text(
                      'Choose Logo Icon',
                      style: TextStyle(
                        color: appColors.textSecondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacingS),
                    SizedBox(
                      height: 150,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: presets.length,
                        itemBuilder: (context, idx) {
                          final preset = presets[idx];
                          final name = preset['name'] as String;
                          final icon = preset['icon'] as IconData;
                          final isSel = selectedIcon == name;
                          final themeColor = Color(int.parse(selectedColorHex));

                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedIcon = name;
                              });
                              setState(() {
                                _logoPath = 'preset:$selectedIcon:$selectedColorHex';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSel ? themeColor.withValues(alpha: 0.15) : appColors.surfaceColor,
                                borderRadius: AppRadius.medium,
                                border: Border.all(
                                  color: isSel ? themeColor : appColors.borderColor,
                                  width: isSel ? 2 : 1,
                                ),
                              ),
                              child: Icon(
                                icon,
                                color: isSel ? themeColor : appColors.textSecondaryColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacingM),
                    SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.medium,
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            _logoPath = 'preset:$selectedIcon:$selectedColorHex';
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Apply Logo',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.company != null;

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
          isEditing ? 'Edit Company Profile' : 'New Company Profile',
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.mainPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Company Details',
                style: TextStyle(
                  color: appColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.spacingM),
              LogoPicker(
                logoPath: _logoPath,
                onTap: _showLogoPicker,
              ),
              const SizedBox(height: AppSpacing.spacingXL),
              LabeledTextField(
                label: 'Company Name',
                hintText: 'e.g. Acme Corp',
                controller: _nameController,
              ),
              const SizedBox(height: AppSpacing.spacingM),
              LabeledTextField(
                label: 'Address',
                hintText: 'Enter company address',
                maxLines: 3,
                controller: _addressController,
              ),
              const SizedBox(height: AppSpacing.spacingM),
              LabeledTextField(
                label: 'Contact Details',
                hintText: 'e.g. email / phone number',
                controller: _contactController,
              ),
              const SizedBox(height: AppSpacing.spacingXL),
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.medium,
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final name = _nameController.text.trim();
                    final address = _addressController.text.trim();
                    final contact = _contactController.text.trim();

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a company name.')),
                      );
                      return;
                    }

                    final result = CompanyModel(
                      id: isEditing ? widget.company!.id : UniqueKey().toString(),
                      name: name,
                      address: address,
                      contactDetails: contact,
                      logoPath: _logoPath,
                    );

                    Navigator.of(context).pop(result);
                  },
                  child: Text(
                    isEditing ? 'Save Changes' : 'Create Profile',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
