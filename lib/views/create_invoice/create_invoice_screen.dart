import 'dart:io';
import 'package:cloud_billr/controllers/company_provider.dart';
import 'package:cloud_billr/controllers/create_invoice_provider.dart';
import 'package:cloud_billr/controllers/customer_provider.dart';
import 'package:cloud_billr/controllers/invoice_config_provider.dart';
import 'package:cloud_billr/controllers/invoice_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/company_model.dart';
import 'package:cloud_billr/models/customer_model.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/create_invoice/widgets/item_card.dart';
import 'package:cloud_billr/views/create_invoice/widgets/template_picker.dart';
import 'package:cloud_billr/views/create_invoice/widgets/totals_section.dart';
import 'package:cloud_billr/helpers/pdf_helper.dart';
import 'package:cloud_billr/views/invoices/pdf_preview_screen.dart';
import 'package:cloud_billr/views/settings/add_edit_company_screen.dart';
import 'package:cloud_billr/views/settings/add_edit_customer_screen.dart';
import 'package:cloud_billr/views/settings/customer_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  bool _configApplied = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_configApplied) {
      _configApplied = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyConfig();
      });
    }
  }

  void _applyConfig() {
    final config =
        Provider.of<InvoiceConfigProvider>(context, listen: false).config;
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);
    final draftProvider =
        Provider.of<CreateInvoiceProvider>(context, listen: false);

    draftProvider.applyConfig(
      taxEnabled: config.taxEnabled,
      taxLabel: config.taxLabel,
      taxRate: config.taxRate,
      taxIsInclusive: config.taxIsInclusive,
      discountEnabled: config.discountEnabled,
      discountType: config.discountType,
      currencySymbol: config.currencySymbol,
      defaultTemplateIndex: config.defaultTemplateIndex,
    );

    if (draftProvider.invoiceNumber.isEmpty) {
      final number = invoiceProvider.generateInvoiceNumber(
        config.invoiceNumberFormat,
        invoiceProvider.nextSequenceNumber,
      );
      draftProvider.setInvoiceNumber(number);
    }
  }

  Widget _buildCompanyLogoWidget(String? logoPath) {
    if (logoPath == null || logoPath.isEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: appColors.secondaryColor,
        child:
            Icon(Icons.business, color: appColors.textSecondaryColor, size: 20),
      );
    }

    if (logoPath.startsWith('preset:')) {
      final parts = logoPath.split(':');
      final iconName = parts.length > 1 ? parts[1] : 'business';
      final colorHex = parts.length > 2 ? parts[2] : '0xFF2196F3';
      final color = Color(int.parse(colorHex));

      IconData iconData;
      switch (iconName) {
        case 'store':
          iconData = Icons.store;
          break;
        case 'computer':
          iconData = Icons.computer;
          break;
        case 'build':
          iconData = Icons.build;
          break;
        case 'shopping_bag':
          iconData = Icons.shopping_bag;
          break;
        case 'account_balance':
          iconData = Icons.account_balance;
          break;
        case 'spa':
          iconData = Icons.spa;
          break;
        case 'restaurant':
          iconData = Icons.restaurant;
          break;
        case 'flash_on':
          iconData = Icons.flash_on;
          break;
        case 'star':
          iconData = Icons.star;
          break;
        case 'palette':
          iconData = Icons.palette;
          break;
        case 'attach_money':
          iconData = Icons.attach_money;
          break;
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

  Future<void> _saveInvoice(BuildContext context) async {
    final companyProvider =
        Provider.of<CompanyProvider>(context, listen: false);
    final draftProvider =
        Provider.of<CreateInvoiceProvider>(context, listen: false);
    final invoiceProvider =
        Provider.of<InvoiceProvider>(context, listen: false);

    if (companyProvider.companies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please create your company profile first.')),
      );
      return;
    }

    if (draftProvider.selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a customer profile first.')),
      );
      return;
    }

    final grandTotal = draftProvider.grandTotal;
    final symbol = draftProvider.currencySymbol;
    final invoiceNumber = draftProvider.invoiceNumber.isNotEmpty
        ? draftProvider.invoiceNumber
        : invoiceProvider.generateInvoiceNumber(
            'INV-{YEAR}-{SEQ}', invoiceProvider.nextSequenceNumber);

    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dateStr = '${months[now.month - 1]} ${now.day}, ${now.year}';

    final newInvoice = InvoiceModel(
      id: UniqueKey().toString(),
      invoiceNumber: invoiceNumber,
      clientName: draftProvider.selectedCustomer!.name,
      status: 'Pending',
      amount: '$symbol${grandTotal.toStringAsFixed(2)}',
      date: dateStr,
      totalAmount: grandTotal,
      templateIndex: draftProvider.selectedTemplateIndex,
      items: draftProvider.items.map((e) => InvoiceItemModel(
        id: e.id,
        name: e.description.isNotEmpty ? e.description : 'Item Details',
        quantity: e.quantity.toInt(),
        rate: e.rate,
        tax: 0.0,
      )).toList(),
    );

    await invoiceProvider.addInvoice(newInvoice);
    draftProvider.reset();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invoice $invoiceNumber created successfully!'),
          backgroundColor: appColors.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
        ),
      );
      Navigator.of(context).pop();
    }
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
          onPressed: () {
            Provider.of<CreateInvoiceProvider>(context, listen: false).reset();
            Navigator.of(context).pop();
          },
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
          Consumer<CreateInvoiceProvider>(
            builder: (ctx, draft, _) => TextButton(
              onPressed: () {
                final customer = draft.selectedCustomer;
                if (customer == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Select a customer to preview the invoice.')),
                  );
                  return;
                }
                final symbol = draft.currencySymbol;
                final now = DateTime.now();
                final months = [
                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                ];
                final preview = InvoiceModel(
                  id: 'preview',
                  invoiceNumber: draft.invoiceNumber.isNotEmpty
                      ? draft.invoiceNumber
                      : 'PREVIEW',
                  clientName: customer.name,
                  status: 'Pending',
                  amount:
                      '$symbol${draft.grandTotal.toStringAsFixed(2)}',
                  date:
                      '${months[now.month - 1]} ${now.day}, ${now.year}',
                  totalAmount: draft.grandTotal,
                  templateIndex: draft.selectedTemplateIndex,
                  items: draft.items.map((e) => InvoiceItemModel(
                    id: e.id,
                    name: e.description.isNotEmpty ? e.description : 'Item Details',
                    quantity: e.quantity.toInt(),
                    rate: e.rate,
                    tax: 0.0,
                  )).toList(),
                );
                final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
                final company = companyProvider.companies.isNotEmpty ? companyProvider.companies.first : null;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PdfPreviewScreen(
                      invoice: preview,
                      companyName: company?.name ?? 'My Company',
                      companyAddress: company?.address ?? '',
                      companyContact: company?.contactDetails ?? '',
                      clientAddress: customer.address,
                      clientEmail: customer.email,
                      currencySymbol: symbol,
                    ),
                  ),
                );
              },
              child: Text(
                'Preview',
                style: TextStyle(
                  color: appColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
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
              // Invoice Number Preview
              Consumer<CreateInvoiceProvider>(
                builder: (_, draft, __) => draft.invoiceNumber.isNotEmpty
                    ? Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.spacingM),
                        child: Row(
                          children: [
                            Icon(Icons.tag,
                                size: 14,
                                color: appColors.textSecondaryColor),
                            const SizedBox(width: 6),
                            Text(
                              draft.invoiceNumber,
                              style: TextStyle(
                                color: appColors.textSecondaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Company Profile Header
              Consumer<CompanyProvider>(
                builder: (context, provider, child) {
                  final companies = provider.companies;
                  if (companies.isEmpty) {
                    return Container(
                      padding:
                          const EdgeInsets.all(AppSpacing.paddingMedium),
                      decoration: BoxDecoration(
                        color: appColors.surfaceColor,
                        borderRadius: AppRadius.medium,
                        border: Border.all(
                            color:
                                appColors.redColor.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: appColors.redColor, size: 36),
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
                            'You must create your company profile in settings before creating an invoice.',
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
                              onPressed: () async {
                                final result =
                                    await Navigator.push<CompanyModel>(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const AddEditCompanyScreen()),
                                );
                                if (result != null && context.mounted) {
                                  await provider.addCompany(result);
                                }
                              },
                              child: const Text(
                                'Create Company Profile',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final myCompany = companies.first;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Billing From',
                        style: TextStyle(
                          color: appColors.textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacingS),
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(AppSpacing.paddingMedium),
                        decoration: BoxDecoration(
                          color: appColors.surfaceColor.withValues(alpha: 0.5),
                          borderRadius: AppRadius.medium,
                          border:
                              Border.all(color: appColors.borderColor),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCompanyLogoWidget(myCompany.logoPath),
                            const SizedBox(width: AppSpacing.spacingM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    myCompany.name,
                                    style: TextStyle(
                                      color: appColors.textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (myCompany.address.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      myCompany.address,
                                      style: TextStyle(
                                        color: appColors.textSecondaryColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                  if (myCompany.contactDetails
                                      .isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      myCompany.contactDetails,
                                      style: TextStyle(
                                        color: appColors.textSecondaryColor
                                            .withValues(alpha: 0.8),
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
                      const SizedBox(height: AppSpacing.spacingM),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.spacingM),

              // Customer Selector
              Consumer2<CustomerProvider, CreateInvoiceProvider>(
                builder: (context, customerProvider, draft, _) {
                  final customers = customerProvider.customers;
                  if (customers.isEmpty) {
                    return Container(
                      padding:
                          const EdgeInsets.all(AppSpacing.paddingMedium),
                      decoration: BoxDecoration(
                        color: appColors.surfaceColor,
                        borderRadius: AppRadius.medium,
                        border: Border.all(
                            color:
                                appColors.redColor.withValues(alpha: 0.5)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: appColors.redColor, size: 36),
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
                            'You must create a customer profile before creating an invoice.',
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
                                    borderRadius: AppRadius.medium),
                              ),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const CustomerListScreen()),
                              ),
                              child: const Text(
                                'Manage Customer Profiles',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (customers.length == 1 &&
                      draft.selectedCustomer == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      draft.setCustomer(customers.first);
                    });
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.paddingMedium),
                        decoration: BoxDecoration(
                          color: appColors.surfaceColor,
                          borderRadius: AppRadius.medium,
                          border: Border.all(
                            color: draft.selectedCustomer == null
                                ? appColors.redColor.withValues(alpha: 0.5)
                                : appColors.borderColor,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<CustomerModel>(
                            value: draft.selectedCustomer,
                            hint: Text(
                              'Choose a customer...',
                              style: TextStyle(
                                color: appColors.textSecondaryColor
                                    .withValues(alpha: 0.5),
                                fontSize: 14,
                              ),
                            ),
                            dropdownColor: appColors.surfaceColor,
                            icon: Icon(Icons.arrow_drop_down,
                                color: appColors.textColor),
                            isExpanded: true,
                            items: customers
                                .map((c) => DropdownMenuItem<CustomerModel>(
                                      value: c,
                                      child: Text(c.name,
                                          style: TextStyle(
                                              color: appColors.textColor,
                                              fontSize: 14)),
                                    ))
                                .toList(),
                            onChanged: (val) => draft.setCustomer(val),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              final result =
                                  await Navigator.push<CustomerModel>(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const AddEditCustomerScreen()),
                              );
                              if (result != null && context.mounted) {
                                await customerProvider.addCustomer(result);
                                draft.setCustomer(result);
                              }
                            },
                            icon: Icon(Icons.add,
                                color: appColors.primaryColor, size: 16),
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
                      if (draft.selectedCustomer != null) ...[
                        const SizedBox(height: AppSpacing.spacingM),
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(AppSpacing.paddingMedium),
                          decoration: BoxDecoration(
                            color: appColors.surfaceColor.withValues(alpha: 0.5),
                            borderRadius: AppRadius.medium,
                            border:
                                Border.all(color: appColors.borderColor),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: appColors.secondaryColor,
                                child: Text(
                                  draft.selectedCustomer!.name
                                          .trim()
                                          .isNotEmpty
                                      ? draft.selectedCustomer!.name
                                          .trim()
                                          .substring(0, 1)
                                          .toUpperCase()
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      draft.selectedCustomer!.name,
                                      style: TextStyle(
                                        color: appColors.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (draft.selectedCustomer!.email
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        draft.selectedCustomer!.email,
                                        style: TextStyle(
                                          color: appColors.textSecondaryColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                    if (draft.selectedCustomer!.phone
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        draft.selectedCustomer!.phone,
                                        style: TextStyle(
                                          color: appColors.textSecondaryColor
                                              .withValues(alpha: 0.8),
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

              // Items Section
              Consumer<CreateInvoiceProvider>(
                builder: (context, draft, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          onPressed: () => draft.addItem(),
                          icon: Icon(Icons.add,
                              color: appColors.primaryColor, size: 18),
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: draft.items.length,
                      itemBuilder: (context, index) {
                        return ItemCard(
                          key: ValueKey(draft.items[index].id),
                          index: index,
                          onRemove: draft.items.length > 1
                              ? () => draft.removeItem(index)
                              : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.spacingM),

              const TotalsSection(),
              const SizedBox(height: AppSpacing.spacingXL),

              const TemplatePicker(),
              const SizedBox(height: AppSpacing.spacingXL),

              // Save Button
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
                  onPressed: () => _saveInvoice(context),
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

              // Export PDF stub
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
                  onPressed: () {
                    final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
                    final draftProvider = Provider.of<CreateInvoiceProvider>(context, listen: false);

                    if (companyProvider.companies.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please create your company profile first.')),
                      );
                      return;
                    }

                    if (draftProvider.selectedCustomer == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select a customer profile first.')),
                      );
                      return;
                    }

                    final company = companyProvider.companies.first;
                    final customer = draftProvider.selectedCustomer!;
                    final symbol = draftProvider.currencySymbol;
                    final grandTotal = draftProvider.grandTotal;

                    final now = DateTime.now();
                    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                    final dateStr = '${months[now.month - 1]} ${now.day}, ${now.year}';

                    final invoiceNumber = draftProvider.invoiceNumber.isNotEmpty
                        ? draftProvider.invoiceNumber
                        : 'DRAFT';

                    final tempInvoice = InvoiceModel(
                      id: 'draft',
                      invoiceNumber: invoiceNumber,
                      clientName: customer.name,
                      status: 'Draft',
                      amount: '$symbol${grandTotal.toStringAsFixed(2)}',
                      date: dateStr,
                      totalAmount: grandTotal,
                      templateIndex: draftProvider.selectedTemplateIndex,
                      items: draftProvider.items.map((e) => InvoiceItemModel(
                        id: e.id,
                        name: e.description.isNotEmpty ? e.description : 'Item Details',
                        quantity: e.quantity.toInt(),
                        rate: e.rate,
                        tax: 0.0,
                      )).toList(),
                    );

                    PdfHelper.exportPdf(
                      context: context,
                      invoice: tempInvoice,
                      companyName: company.name,
                      companyAddress: company.address,
                      companyContact: company.contactDetails,
                      clientAddress: customer.address,
                      clientEmail: customer.email,
                      currencySymbol: symbol,
                    );
                  },
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
