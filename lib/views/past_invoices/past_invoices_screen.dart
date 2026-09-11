import 'package:cloud_billr/controllers/invoice_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/past_invoices/widgets/past_invoice_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PastInvoicesScreen extends StatefulWidget {
  const PastInvoicesScreen({super.key});

  @override
  State<PastInvoicesScreen> createState() => _PastInvoicesScreenState();
}

class _PastInvoicesScreenState extends State<PastInvoicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'All';

  static const List<String> _filterOptions = [
    'All',
    'Paid',
    'Pending',
    'Overdue',
  ];

  static const Map<String, Color> _filterColors = {
    'Paid': Color(0xFF16A34A),
    'Pending': Color(0xFFCA8A04),
    'Overdue': Color(0xFFDC2626),
  };

  List<InvoiceModel> _applyFilters(List<InvoiceModel> invoices) {
    final query = _searchQuery.toLowerCase();
    return invoices.where((invoice) {
      final matchesSearch = query.isEmpty ||
          invoice.invoiceNumber.toLowerCase().contains(query) ||
          invoice.clientName.toLowerCase().contains(query);
      final matchesStatus = _statusFilter == 'All' ||
          invoice.status.toLowerCase() == _statusFilter.toLowerCase();
      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setSheet) {
          return Container(
            decoration: BoxDecoration(
              color: appColors.backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
                AppSpacing.mainPadding,
                AppSpacing.paddingLarge,
                AppSpacing.mainPadding,
                AppSpacing.paddingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: appColors.borderColor,
                      borderRadius: AppRadius.circle,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.spacingL),
                Text(
                  'Filter by Status',
                  style: TextStyle(
                    color: appColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSpacing.spacingM),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _filterOptions.map((option) {
                    final isSelected = _statusFilter == option;
                    final accent = option == 'All'
                        ? appColors.primaryColor
                        : (_filterColors[option] ?? appColors.primaryColor);
                    return GestureDetector(
                      onTap: () {
                        setSheet(() {});
                        setState(() => _statusFilter = option);
                        Navigator.pop(ctx);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? accent.withValues(alpha: 0.15)
                              : appColors.borderColor.withValues(alpha: 0.2),
                          borderRadius: AppRadius.circle,
                          border: Border.all(
                            color: isSelected ? accent : appColors.borderColor,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          option,
                          style: TextStyle(
                            color: isSelected ? accent : appColors.textColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: AppSpacing.spacingL),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invoices = Provider.of<InvoiceProvider>(context).invoices;
    final filtered = _applyFilters(List<InvoiceModel>.from(invoices));

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
          'Past Invoices',
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.filter_list, color: appColors.textColor),
                onPressed: _showFilterSheet,
              ),
              if (_statusFilter != 'All')
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: appColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.mainPadding),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.spacingS),
              // Active filter chip
              if (_statusFilter != 'All')
                Padding(
                  padding:
                      EdgeInsets.only(bottom: AppSpacing.spacingS),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: (_filterColors[_statusFilter] ??
                                  appColors.primaryColor)
                              .withValues(alpha: 0.12),
                          borderRadius: AppRadius.circle,
                          border: Border.all(
                              color: _filterColors[_statusFilter] ??
                                  appColors.primaryColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _statusFilter,
                              style: TextStyle(
                                color: _filterColors[_statusFilter] ??
                                    appColors.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _statusFilter = 'All'),
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: _filterColors[_statusFilter] ??
                                    appColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: appColors.surfaceColor,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(color: appColors.borderColor),
                ),
                child: TextField(
                  controller: _searchController,
                  style:
                      TextStyle(color: appColors.textColor, fontSize: 14),
                  onChanged: (value) =>
                      setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search invoices...',
                    hintStyle: TextStyle(
                      color: appColors.textSecondaryColor
                          .withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: appColors.textSecondaryColor
                          .withValues(alpha: 0.6),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear,
                                color: appColors.textSecondaryColor),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.spacingL),
              // List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined,
                                size: 48,
                                color: appColors.textSecondaryColor
                                    .withValues(alpha: 0.4)),
                            SizedBox(height: AppSpacing.spacingM),
                            Text(
                              'No invoices found',
                              style: TextStyle(
                                  color: appColors.textSecondaryColor),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => PastInvoiceCard(
                          invoice: filtered[index],
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
