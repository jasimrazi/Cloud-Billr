import 'package:cloud_billr/controllers/invoice_provider.dart';
import 'package:cloud_billr/controllers/company_provider.dart';
import 'package:cloud_billr/controllers/customer_provider.dart';
import 'package:cloud_billr/controllers/invoice_config_provider.dart';
import 'package:cloud_billr/helpers/pdf_helper.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:cloud_billr/models/customer_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoiceDetailScreen extends StatefulWidget {
  final InvoiceModel invoice;
  final bool previewMode;

  const InvoiceDetailScreen({
    super.key,
    required this.invoice,
    this.previewMode = false,
  });

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  late InvoiceModel _invoice;

  @override
  void initState() {
    super.initState();
    _invoice = widget.invoice;
  }

  static const List<String> _statuses = ['Paid', 'Pending', 'Overdue'];

  static const Map<String, Color> _statusBgColors = {
    'paid': Color(0xFFDCFCE7),
    'pending': Color(0xFFFEF9C3),
    'overdue': Color(0xFFFFE4E6),
  };

  static const Map<String, Color> _statusTextColors = {
    'paid': Color(0xFF16A34A),
    'pending': Color(0xFFCA8A04),
    'overdue': Color(0xFFDC2626),
  };

  Color _statusBg(String status) =>
      _statusBgColors[status.toLowerCase()] ?? appColors.borderColor;

  Color _statusFg(String status) =>
      _statusTextColors[status.toLowerCase()] ?? appColors.textColor;

  Future<void> _showMarkAsDialog() async {
    final chosen = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: appColors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: Text(
          'Change Status',
          style: TextStyle(
            color: appColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _statuses.map((s) {
            final isCurrentStatus =
                s.toLowerCase() == _invoice.status.toLowerCase();
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _statusFg(s),
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(
                s,
                style: TextStyle(
                  color: appColors.textColor,
                  fontWeight: isCurrentStatus
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              trailing: isCurrentStatus
                  ? Icon(Icons.check, color: appColors.primaryColor, size: 18)
                  : null,
              onTap: () => Navigator.of(ctx).pop(s),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: TextStyle(color: appColors.textSecondaryColor)),
          ),
        ],
      ),
    );

    if (chosen == null ||
        chosen.toLowerCase() == _invoice.status.toLowerCase()) {
      return;
    }
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: appColors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: Text(
          'Confirm Status Change',
          style: TextStyle(
            color: appColors.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Mark ${_invoice.invoiceNumber} as $chosen?\n\n'
          'This will update the invoice status and reflect in your revenue and pending totals.',
          style: TextStyle(color: appColors.textSecondaryColor, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel',
                style: TextStyle(color: appColors.textSecondaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await Provider.of<InvoiceProvider>(context, listen: false)
        .updateInvoiceStatus(_invoice.id, chosen);
    if (!mounted) return;
    setState(() {
      _invoice = _invoice.copyWith(status: chosen);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_invoice.invoiceNumber} marked as $chosen'),
        backgroundColor: _statusFg(chosen),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: appColors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
        title: Text(
          'Delete Invoice',
          style: TextStyle(
              color: appColors.textColor, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Delete ${_invoice.invoiceNumber}? This action cannot be undone.',
          style: TextStyle(color: appColors.textSecondaryColor, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel',
                style: TextStyle(color: appColors.textSecondaryColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.redColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    if (mounted) {
      await Provider.of<InvoiceProvider>(context, listen: false)
          .deleteInvoice(_invoice.id);
      if (mounted) Navigator.of(context).pop();
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.previewMode ? 'Preview' : 'Invoice Detail',
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!widget.previewMode)
            IconButton(
              icon: Icon(Icons.delete_outline, color: appColors.redColor),
              onPressed: _confirmDelete,
              tooltip: 'Delete Invoice',
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.mainPadding),
          physics: const BouncingScrollPhysics(),
          children: [
            // ── Invoice Header ──────────────────────────────────────
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _invoice.invoiceNumber,
                          style: TextStyle(
                            color: appColors.textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: _statusBg(_invoice.status),
                          borderRadius: AppRadius.circle,
                        ),
                        child: Text(
                          _invoice.status,
                          style: TextStyle(
                            color: _statusFg(_invoice.status),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 14, color: appColors.textSecondaryColor),
                      const SizedBox(width: 6),
                      Text(
                        _invoice.date,
                        style: TextStyle(
                          color: appColors.textSecondaryColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingM),

            // ── Bill To ─────────────────────────────────────────────
            _SectionLabel(label: 'Bill To'),
            _Card(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: appColors.secondaryColor,
                    child: Text(
                      _invoice.clientName.isNotEmpty
                          ? _invoice.clientName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: appColors.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacingM),
                  Text(
                    _invoice.clientName,
                    style: TextStyle(
                      color: appColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingM),

            if (_invoice.items.isNotEmpty) ...[
              _SectionLabel(label: 'Items'),
              _Card(
                child: Column(
                  children: _invoice.items.map((item) {
                    final symbol = Provider.of<InvoiceConfigProvider>(context, listen: false).config.currencySymbol;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    color: appColors.textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Qty: ${item.quantity} × $symbol${item.rate.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: appColors.textSecondaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '$symbol${item.lineTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: appColors.textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.spacingM),
            ],

            // ── Totals ───────────────────────────────────────────────
            _SectionLabel(label: 'Totals'),
            _Card(
              child: Column(
                children: [
                  _TotalRow(
                    label: 'Amount',
                    value: _invoice.amount,
                    isBold: true,
                    valueColor: appColors.textColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingXL),

            // ── Actions ──────────────────────────────────────────────
            if (!widget.previewMode) ...[
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.medium),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text(
                    'Mark as…',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _showMarkAsDialog,
                ),
              ),
              const SizedBox(height: AppSpacing.spacingM),
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: appColors.borderColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.medium),
                  ),
                  icon: Icon(Icons.picture_as_pdf_outlined,
                      size: 18, color: appColors.textSecondaryColor),
                  label: Text(
                    'Export PDF',
                    style: TextStyle(
                      color: appColors.textSecondaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
                    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
                    final configProvider = Provider.of<InvoiceConfigProvider>(context, listen: false);

                    final company = companyProvider.companies.isNotEmpty ? companyProvider.companies.first : null;
                    final client = customerProvider.customers.firstWhere(
                      (c) => c.name.toLowerCase() == _invoice.clientName.toLowerCase(),
                      orElse: () => CustomerModel(id: '', name: _invoice.clientName, address: '', email: '', phone: ''),
                    );

                    PdfHelper.exportPdf(
                      context: context,
                      invoice: _invoice,
                      companyName: company?.name,
                      companyAddress: company?.address,
                      companyContact: company?.contactDetails,
                      clientAddress: client.address,
                      clientEmail: client.email,
                      currencySymbol: configProvider.config.currencySymbol,
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.spacingXL),
          ],
        ),
      ),
    );
  }
}

// ── Private layout helpers ───────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.paddingMedium),
      decoration: BoxDecoration(
        color: appColors.backgroundColor,
        borderRadius: AppRadius.large,
        border: Border.all(color: appColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: appColors.textSecondaryColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _TotalRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: appColors.textSecondaryColor,
            fontSize: isBold ? 15 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? appColors.textColor,
            fontSize: isBold ? 15 : 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
