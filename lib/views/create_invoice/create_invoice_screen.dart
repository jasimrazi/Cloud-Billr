import 'dart:io';
import 'package:cloud_billr/controllers/company_provider.dart';
import 'package:cloud_billr/controllers/customer_provider.dart';
import 'package:cloud_billr/controllers/invoice_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/company_model.dart';
import 'package:cloud_billr/models/customer_model.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/create_invoice/widgets/item_card.dart';
import 'package:cloud_billr/views/create_invoice/widgets/template_picker.dart';
import 'package:cloud_billr/views/create_invoice/widgets/totals_section.dart';
import 'package:cloud_billr/views/settings/add_edit_company_screen.dart';
import 'package:cloud_billr/views/settings/add_edit_customer_screen.dart';
import 'package:cloud_billr/views/settings/company_list_screen.dart';
import 'package:cloud_billr/views/settings/customer_list_screen.dart';
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

  CompanyModel? _selectedCompany;
  CustomerModel? _selectedCustomer;

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildCompanyLogoWidget(String? logoPath) {
    if (logoPath == null || logoPath.isEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: appColors.secondaryColor,
        child: Icon(Icons.business, color: appColors.textSecondaryColor, size: 20),
      );
    }
    
    if (logoPath.startsWith('preset:')) {
      final parts = logoPath.split(':');
      final iconName = parts.length > 1 ? parts[1] : 'business';
      final colorHex = parts.length > 2 ? parts[2] : '0xFF2196F3';
      final color = Color(int.parse(colorHex));
      
      IconData iconData;
      switch (iconName) {
        case 'store': iconData = Icons.store; break;
        case 'computer': iconData = Icons.computer; break;
        case 'build': iconData = Icons.build; break;
        case 'shopping_bag': iconData = Icons.shopping_bag; break;
        case 'account_balance': iconData = Icons.account_balance; break;
        case 'spa': iconData = Icons.spa; break;
        case 'restaurant': iconData = Icons.restaurant; break;
        case 'flash_on': iconData = Icons.flash_on; break;
        case 'star': iconData = Icons.star; break;
        case 'palette': iconData = Icons.palette; break;
        case 'attach_money': iconData = Icons.attach_money; break;
        case 'business':
        default:
          iconData = Icons.business;
          break;
      }

      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(iconData, size: 20, color: color),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.file(
        File(logoPath),
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => CircleAvatar(
          radius: 20,
          backgroundColor: appColors.secondaryColor,
          child: Icon(Icons.broken_image, color: appColors.redColor, size: 20),
        ),
      ),
    );
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
              // Saved Company Profiles Dropdown Selector
              Consumer<CompanyProvider>(
                builder: (context, provider, child) {
                  final companies = provider.companies;
                  if (companies.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.paddingMedium),
                      decoration: BoxDecoration(
                        color: appColors.surfaceColor,
                        borderRadius: AppRadius.medium,
                        border: Border.all(color: appColors.redColor.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: appColors.redColor, size: 36),
                          const SizedBox(height: AppSpacing.spacingS),
                          Text(
                            'No Company Profile Found',
                            style: TextStyle(
                              color: appColors.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spacingXS),
                          Text(
                            'You must create a company profile in settings before creating an invoice.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: appColors.textSecondaryColor,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spacingM),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.medium,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CompanyListScreen()),
                                );
                              },
                              child: const Text(
                                'Manage Company Profiles',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Saved Company Profile (Required)',
                        style: TextStyle(
                          color: appColors.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacingS),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingMedium),
                        decoration: BoxDecoration(
                          color: appColors.surfaceColor,
                          borderRadius: AppRadius.medium,
                          border: Border.all(
                            color: _selectedCompany == null ? appColors.redColor.withValues(alpha: 0.5) : appColors.borderColor,
                          ),
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
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push<CompanyModel>(
                                context,
                                MaterialPageRoute(builder: (_) => const AddEditCompanyScreen()),
                              );

                              if (result != null && context.mounted) {
                                final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
                                await companyProvider.addCompany(result);
                                setState(() {
                                  _selectedCompany = result;
                                });
                              }
                            },
                            icon: Icon(Icons.add, color: appColors.primaryColor, size: 16),
                            label: Text(
                              'Add Company',
                              style: TextStyle(
                                color: appColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedCompany != null) ...[
                        const SizedBox(height: AppSpacing.spacingM),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.paddingMedium),
                          decoration: BoxDecoration(
                            color: appColors.surfaceColor.withValues(alpha: 0.5),
                            borderRadius: AppRadius.medium,
                            border: Border.all(color: appColors.borderColor),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCompanyLogoWidget(_selectedCompany!.logoPath),
                              const SizedBox(width: AppSpacing.spacingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedCompany!.name,
                                      style: TextStyle(
                                        color: appColors.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (_selectedCompany!.address.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        _selectedCompany!.address,
                                        style: TextStyle(
                                          color: appColors.textSecondaryColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                    if (_selectedCompany!.contactDetails.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        _selectedCompany!.contactDetails,
                                        style: TextStyle(
                                          color: appColors.textSecondaryColor.withValues(alpha: 0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.spacingM),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.spacingM),

              // Saved Customer Profiles Dropdown Selector
              Consumer<CustomerProvider>(
                builder: (context, provider, child) {
                  final customers = provider.customers;
                  if (customers.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.paddingMedium),
                      decoration: BoxDecoration(
                        color: appColors.surfaceColor,
                        borderRadius: AppRadius.medium,
                        border: Border.all(color: appColors.redColor.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: appColors.redColor, size: 36),
                          const SizedBox(height: AppSpacing.spacingS),
                          Text(
                            'No Customer Profile Found',
                            style: TextStyle(
                              color: appColors.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spacingXS),
                          Text(
                            'You must create a customer profile in settings before creating an invoice.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: appColors.textSecondaryColor,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.spacingM),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.medium,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CustomerListScreen()),
                                );
                              },
                              child: const Text(
                                'Manage Customer Profiles',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Saved Customer Profile (Required)',
                        style: TextStyle(
                          color: appColors.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacingS),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingMedium),
                        decoration: BoxDecoration(
                          color: appColors.surfaceColor,
                          borderRadius: AppRadius.medium,
                          border: Border.all(
                            color: _selectedCustomer == null ? appColors.redColor.withValues(alpha: 0.5) : appColors.borderColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<CustomerModel>(
                            value: _selectedCustomer,
                            hint: Text(
                              'Choose a customer...',
                              style: TextStyle(
                                color: appColors.textSecondaryColor.withValues(alpha: 0.5),
                                fontSize: 14,
                              ),
                            ),
                            dropdownColor: appColors.surfaceColor,
                            icon: Icon(Icons.arrow_drop_down, color: appColors.textColor),
                            isExpanded: true,
                            items: customers.map((customer) {
                              return DropdownMenuItem<CustomerModel>(
                                value: customer,
                                child: Text(
                                  customer.name,
                                  style: TextStyle(
                                    color: appColors.textColor,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (CustomerModel? value) {
                              setState(() {
                                _selectedCustomer = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push<CustomerModel>(
                                context,
                                MaterialPageRoute(builder: (_) => const AddEditCustomerScreen()),
                              );

                              if (result != null && context.mounted) {
                                final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
                                await customerProvider.addCustomer(result);
                                setState(() {
                                  _selectedCustomer = result;
                                });
                              }
                            },
                            icon: Icon(Icons.add, color: appColors.primaryColor, size: 16),
                            label: Text(
                              'Add Customer',
                              style: TextStyle(
                                color: appColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedCustomer != null) ...[
                        const SizedBox(height: AppSpacing.spacingM),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.paddingMedium),
                          decoration: BoxDecoration(
                            color: appColors.surfaceColor.withValues(alpha: 0.5),
                            borderRadius: AppRadius.medium,
                            border: Border.all(color: appColors.borderColor),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: appColors.secondaryColor,
                                child: Text(
                                  _selectedCustomer!.name.trim().isNotEmpty
                                      ? _selectedCustomer!.name.trim().substring(0, 1).toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    color: appColors.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.spacingM),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedCustomer!.name,
                                      style: TextStyle(
                                        color: appColors.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (_selectedCustomer!.email.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        _selectedCustomer!.email,
                                        style: TextStyle(
                                          color: appColors.textSecondaryColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                    if (_selectedCustomer!.phone.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        _selectedCustomer!.phone,
                                        style: TextStyle(
                                          color: appColors.textSecondaryColor.withValues(alpha: 0.8),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                    if (_selectedCustomer!.address.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        _selectedCustomer!.address,
                                        style: TextStyle(
                                          color: appColors.textSecondaryColor.withValues(alpha: 0.6),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.spacingM),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.spacingM),

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
                    if (_selectedCompany == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a company profile first.')),
                      );
                      return;
                    }

                    if (_selectedCustomer == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a customer profile first.')),
                      );
                      return;
                    }

                    final now = DateTime.now();
                    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                    final dateStr = '${months[now.month - 1]} ${now.day}, ${now.year}';

                    final newInvoice = InvoiceModel(
                      id: UniqueKey().toString(),
                      invoiceNumber: 'INV-${now.year}-${1000 + (now.microsecond % 9000)}',
                      clientName: _selectedCustomer!.name,
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
