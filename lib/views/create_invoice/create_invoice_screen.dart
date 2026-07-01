import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/create_invoice/widgets/item_card.dart';
import 'package:cloud_billr/views/create_invoice/widgets/labeled_text_field.dart';
import 'package:cloud_billr/views/create_invoice/widgets/logo_picker.dart';
import 'package:cloud_billr/views/create_invoice/widgets/template_picker.dart';
import 'package:cloud_billr/views/create_invoice/widgets/totals_section.dart';
import 'package:flutter/material.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _HomeScreenItem {
  final Key key = UniqueKey();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  // Dynamically track list of items for the form
  final List<_HomeScreenItem> _items = [_HomeScreenItem()];

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
          'Create Invoice',
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Preview',
              style: TextStyle(
                color: appColors.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.mainPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LogoPicker(),
              const SizedBox(height: AppSpacing.spacingXL),
              
              // Company Info Section
              const LabeledTextField(
                label: 'Company Name',
                hintText: 'Enter company name',
              ),
              const SizedBox(height: AppSpacing.spacingM),
              const LabeledTextField(
                label: 'Company Address',
                hintText: 'Enter company address',
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.spacingM),
              const LabeledTextField(
                label: 'Contact Details',
                hintText: 'Enter contact details',
              ),
              const SizedBox(height: AppSpacing.spacingXL),

              // Customer Details Section
              Text(
                'Customer Details',
                style: TextStyle(
                  color: appColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.spacingM),
              const LabeledTextField(
                label: 'Customer Name',
                hintText: 'Enter customer name',
              ),
              const SizedBox(height: AppSpacing.spacingM),
              const LabeledTextField(
                label: 'Email Address',
                hintText: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.spacingM),
              const LabeledTextField(
                label: 'Billing Address',
                hintText: 'Enter billing address',
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.spacingM),
              const LabeledTextField(
                label: 'Phone Number',
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.spacingXL),

              // Items Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Items',
                    style: TextStyle(
                      color: appColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _items.add(_HomeScreenItem());
                      });
                    },
                    icon: Icon(Icons.add, color: appColors.primaryColor, size: 18),
                    label: Text(
                      'Add Item',
                      style: TextStyle(
                        color: appColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingS),

              // Item Cards List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ItemCard(
                    key: _items[index].key,
                    index: index,
                    onRemove: _items.length > 1
                        ? () {
                            setState(() {
                              _items.removeAt(index);
                            });
                          }
                        : null,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.spacingM),

              const TotalsSection(),
              const SizedBox(height: AppSpacing.spacingXL),

              const TemplatePicker(),
              const SizedBox(height: AppSpacing.spacingXL),

              // Action Buttons
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
                  onPressed: () {},
                  child: const Text(
                    'Save Invoice',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spacingM),
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: appColors.surfaceColor,
                    side: BorderSide(color: appColors.borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.medium,
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'Export PDF',
                    style: TextStyle(
                      color: appColors.textSecondaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spacingXL),
            ],
          ),
        ),
      ),
    );
  }
}
