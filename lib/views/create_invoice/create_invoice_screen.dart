import 'package:cloud_billr/controllers/company_provider.dart';
import 'package:cloud_billr/controllers/invoice_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/company_model.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/create_invoice/widgets/item_card.dart';
import 'package:cloud_billr/views/create_invoice/widgets/labeled_text_field.dart';
import 'package:cloud_billr/views/create_invoice/widgets/logo_picker.dart';
import 'package:cloud_billr/views/create_invoice/widgets/template_picker.dart';
import 'package:cloud_billr/views/create_invoice/widgets/totals_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _companyContactController = TextEditingController();
  final _customerNameController = TextEditingController();
  CompanyModel? _selectedCompany;

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _companyContactController.dispose();
    _customerNameController.dispose();
    super.dispose();
  }

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

              // Saved Company Profiles Dropdown Selector
              Consumer<CompanyProvider>(
                builder: (context, provider, child) {
                  final companies = provider.companies;
                  if (companies.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Saved Company Profile',
                        style: TextStyle(
                          color: appColors.textColor.withValues(alpha: 0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacingS),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingMedium),
                        decoration: BoxDecoration(
                          color: appColors.surfaceColor,
                          borderRadius: AppRadius.medium,
                          border: Border.all(color: appColors.borderColor),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<CompanyModel>(
                            value: _selectedCompany,
                            hint: Text(
                              'Choose a company...',
                              style: TextStyle(
                                color: appColors.textSecondaryColor.withValues(alpha: 0.5),
                                fontSize: 14,
                              ),
                            ),
                            dropdownColor: appColors.surfaceColor,
                            icon: Icon(Icons.arrow_drop_down, color: appColors.textColor),
                            isExpanded: true,
                            items: companies.map((company) {
                              return DropdownMenuItem<CompanyModel>(
                                value: company,
                                child: Text(
                                  company.name,
                                  style: TextStyle(
                                    color: appColors.textColor,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (CompanyModel? value) {
                              setState(() {
                                _selectedCompany = value;
                                if (value != null) {
                                  _companyNameController.text = value.name;
                                  _companyAddressController.text = value.address;
                                  _companyContactController.text = value.contactDetails;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacingM),
                    ],
                  );
                },
              ),

              // Company Info Section
              LabeledTextField(
                label: 'Company Name',
                hintText: 'Enter company name',
                controller: _companyNameController,
              ),
              const SizedBox(height: AppSpacing.spacingM),
              LabeledTextField(
                label: 'Company Address',
                hintText: 'Enter company address',
                maxLines: 3,
                controller: _companyAddressController,
              ),
              const SizedBox(height: AppSpacing.spacingM),
              LabeledTextField(
                label: 'Contact Details',
                hintText: 'Enter contact details',
                controller: _companyContactController,
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
              LabeledTextField(
                label: 'Customer Name',
                hintText: 'Enter customer name',
                controller: _customerNameController,
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
                  onPressed: () {
                    final clientName = _customerNameController.text.trim();
                    if (clientName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a customer name.')),
                      );
                      return;
                    }

                    final now = DateTime.now();
                    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                    final dateStr = '${months[now.month - 1]} ${now.day}, ${now.year}';

                    final newInvoice = InvoiceModel(
                      id: UniqueKey().toString(),
                      invoiceNumber: 'INV-${now.year}-${1000 + (now.microsecond % 9000)}',
                      clientName: clientName,
                      status: 'Pending',
                      amount: '\$1,500.00', // Simulated total amount
                      date: dateStr,
                    );

                    Provider.of<InvoiceProvider>(context, listen: false).addInvoice(newInvoice);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invoice ${newInvoice.invoiceNumber} created successfully!')),
                    );

                    Navigator.of(context).pop();
                  },
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
