import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/past_invoices/widgets/past_invoice_card.dart';
import 'package:flutter/material.dart';

class PastInvoicesScreen extends StatefulWidget {
  const PastInvoicesScreen({super.key});

  @override
  State<PastInvoicesScreen> createState() => _PastInvoicesScreenState();
}

class _PastInvoicesScreenState extends State<PastInvoicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _mockInvoices = [
    {
      'title': 'Website Development',
      'client': 'Tech Solutions Inc.',
      'date': 'Jan 15, 2024',
      'amount': '\$2,500.00',
    },
    {
      'title': 'Marketing Campaign',
      'client': 'Global Brands Ltd.',
      'date': 'Jan 12, 2024',
      'amount': '\$1,800.00',
    },
    {
      'title': 'Consulting Services',
      'client': 'Innovation Hub',
      'date': 'Jan 10, 2024',
      'amount': '\$3,200.00',
    },
    {
      'title': 'Product Design',
      'client': 'Creative Studio',
      'date': 'Jan 8, 2024',
      'amount': '\$1,500.00',
    },
    {
      'title': 'Software License',
      'client': 'Digital Systems',
      'date': 'Jan 5, 2024',
      'amount': '\$4,800.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter mock invoices based on search query
    final filteredInvoices = _mockInvoices.where((invoice) {
      final query = _searchQuery.toLowerCase();
      final titleMatch = invoice['title']?.toLowerCase().contains(query) ?? false;
      final clientMatch = invoice['client']?.toLowerCase().contains(query) ?? false;
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
                      color: appColors.textSecondaryColor.withOpacity(0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: appColors.textSecondaryColor.withOpacity(0.6),
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
                            title: invoice['title']!,
                            clientName: invoice['client']!,
                            date: invoice['date']!,
                            amount: invoice['amount']!,
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
