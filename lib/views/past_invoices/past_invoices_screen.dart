import 'package:cloud_billr/controllers/invoice_provider.dart';
import 'package:cloud_billr/main.dart';
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

  @override
  Widget build(BuildContext context) {
    final invoices = Provider.of<InvoiceProvider>(context).invoices;

    // Filter invoices based on search query
    final filteredInvoices = invoices.where((invoice) {
      final query = _searchQuery.toLowerCase();
      final titleMatch = invoice.invoiceNumber.toLowerCase().contains(query);
      final clientMatch = invoice.clientName.toLowerCase().contains(query);
      return titleMatch || clientMatch;
    }).toList();

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
          IconButton(
            icon: Icon(Icons.filter_list, color: appColors.textColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.mainPadding),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.spacingS),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: appColors.surfaceColor,
                  borderRadius: AppRadius.medium,
                  border: Border.all(color: appColors.borderColor),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: appColors.textColor, fontSize: 14),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search invoices...',
                    hintStyle: TextStyle(
                      color: appColors.textSecondaryColor.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: appColors.textSecondaryColor.withValues(alpha: 0.6),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: appColors.textSecondaryColor),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.spacingL),
              // Invoices List
              Expanded(
                child: filteredInvoices.isEmpty
                    ? Center(
                        child: Text(
                          'No invoices found',
                          style: TextStyle(color: appColors.textSecondaryColor),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredInvoices.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final invoice = filteredInvoices[index];
                          return PastInvoiceCard(
                            title: invoice.invoiceNumber,
                            clientName: invoice.clientName,
                            date: invoice.date,
                            amount: invoice.amount,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
