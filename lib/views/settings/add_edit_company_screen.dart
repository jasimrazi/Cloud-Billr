import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/company_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/create_invoice/widgets/labeled_text_field.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.company != null) {
      _nameController.text = widget.company!.name;
      _addressController.text = widget.company!.address;
      _contactController.text = widget.company!.contactDetails;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
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
