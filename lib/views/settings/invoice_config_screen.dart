import 'package:cloud_billr/controllers/invoice_config_provider.dart';
import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/models/invoice_template_config_model.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:cloud_billr/views/settings/widgets/invoice_column_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class InvoiceConfigScreen extends StatefulWidget {
  const InvoiceConfigScreen({super.key});

  @override
  State<InvoiceConfigScreen> createState() => _InvoiceConfigScreenState();
}

class _InvoiceConfigScreenState extends State<InvoiceConfigScreen> {
  late InvoiceTemplateConfig _config;
  bool _initialized = false;
  bool _saving = false;

  // Controllers
  final _numberFormatController = TextEditingController();
  final _numberStartAtController = TextEditingController();
  final _taxLabelController = TextEditingController();
  final _taxRateController = TextEditingController();
  final _shippingLabelController = TextEditingController();
  final _netDaysController = TextEditingController();
  final _defaultNotesController = TextEditingController();
  final _defaultTermsController = TextEditingController();

  // Currency data
  static const List<Map<String, String>> _currencies = [
    {'code': 'USD', 'symbol': '\$', 'label': 'USD — US Dollar'},
    {'code': 'EUR', 'symbol': '€', 'label': 'EUR — Euro'},
    {'code': 'GBP', 'symbol': '£', 'label': 'GBP — British Pound'},
    {'code': 'INR', 'symbol': '₹', 'label': 'INR — Indian Rupee'},
    {'code': 'AED', 'symbol': 'د.إ', 'label': 'AED — UAE Dirham'},
    {'code': 'CAD', 'symbol': 'CA\$', 'label': 'CAD — Canadian Dollar'},
    {'code': 'AUD', 'symbol': 'A\$', 'label': 'AUD — Australian Dollar'},
    {'code': 'JPY', 'symbol': '¥', 'label': 'JPY — Japanese Yen'},
    {'code': 'SGD', 'symbol': 'S\$', 'label': 'SGD — Singapore Dollar'},
    {'code': 'MYR', 'symbol': 'RM', 'label': 'MYR — Malaysian Ringgit'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _config =
          Provider.of<InvoiceConfigProvider>(context, listen: false).config;
      _syncControllersFromConfig();
      _initialized = true;
    }
  }

  void _syncControllersFromConfig() {
    _numberFormatController.text = _config.invoiceNumberFormat;
    _numberStartAtController.text = _config.invoiceNumberStartAt.toString();
    _taxLabelController.text = _config.taxLabel;
    _taxRateController.text = _config.taxRate == 0
        ? ''
        : _config.taxRate.toStringAsFixed(
            _config.taxRate.truncateToDouble() == _config.taxRate ? 0 : 2);
    _shippingLabelController.text = _config.shippingLabel;
    _netDaysController.text = _config.netDays.toString();
    _defaultNotesController.text = _config.defaultNotes;
    _defaultTermsController.text = _config.defaultTerms;
  }

  InvoiceTemplateConfig _buildConfigFromState() {
    return _config.copyWith(
      invoiceNumberFormat: _numberFormatController.text.trim().isEmpty
          ? 'INV-{YEAR}-{SEQ}'
          : _numberFormatController.text.trim(),
      invoiceNumberStartAt:
          int.tryParse(_numberStartAtController.text.trim()) ?? 1,
      taxLabel: _taxLabelController.text.trim().isEmpty
          ? 'Tax'
          : _taxLabelController.text.trim(),
      taxRate: double.tryParse(_taxRateController.text.trim()) ?? 0.0,
      shippingLabel: _shippingLabelController.text.trim().isEmpty
          ? 'Shipping & Handling'
          : _shippingLabelController.text.trim(),
      netDays: int.tryParse(_netDaysController.text.trim()) ?? 30,
      defaultNotes: _defaultNotesController.text,
      defaultTerms: _defaultTermsController.text,
    );
  }

  String _buildNumberFormatPreview(String format) {
    final year = DateTime.now().year.toString();
    return format
        .replaceAll('{YEAR}', year)
        .replaceAll('{MONTH}', '07')
        .replaceAll('{SEQ}', '001');
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final finalConfig = _buildConfigFromState();
    await Provider.of<InvoiceConfigProvider>(context, listen: false)
        .saveConfig(finalConfig);
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invoice settings saved'),
          backgroundColor: appColors.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: AppRadius.medium),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _numberFormatController.dispose();
    _numberStartAtController.dispose();
    _taxLabelController.dispose();
    _taxRateController.dispose();
    _shippingLabelController.dispose();
    _netDaysController.dispose();
    _defaultNotesController.dispose();
    _defaultTermsController.dispose();
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
          'Manage Invoice',
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.mainPadding,
            vertical: AppSpacing.paddingSmall,
          ),
          physics: const BouncingScrollPhysics(),
          children: [
            // ── Invoice Numbering ──────────────────────────────────────
            _SectionHeader(title: 'Invoice Numbering'),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Number Format'),
                  const SizedBox(height: AppSpacing.spacingS),
                  _buildTextField(
                    controller: _numberFormatController,
                    hint: 'e.g. INV-{YEAR}-{SEQ}',
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 6),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _numberFormatController,
                    builder: (_, val, __) {
                      final preview =
                          _buildNumberFormatPreview(val.text.isEmpty
                              ? 'INV-{YEAR}-{SEQ}'
                              : val.text);
                      return Row(
                        children: [
                          Icon(Icons.preview_outlined,
                              size: 14,
                              color: appColors.textSecondaryColor),
                          const SizedBox(width: 4),
                          Text(
                            'Preview: $preview',
                            style: TextStyle(
                              color: appColors.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Available tokens: {YEAR}, {MONTH}, {SEQ}',
                    style: TextStyle(
                      color: appColors.textSecondaryColor,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacingM),
                  _buildLabel('Starting Number'),
                  const SizedBox(height: AppSpacing.spacingS),
                  _buildTextField(
                    controller: _numberStartAtController,
                    hint: '1',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingM),

            // ── Currency ───────────────────────────────────────────────
            _SectionHeader(title: 'Currency'),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Select Currency'),
                  const SizedBox(height: AppSpacing.spacingS),
                  _buildDropdown<String>(
                    value: _config.currency,
                    items: _currencies
                        .map((c) => DropdownMenuItem(
                              value: c['code'],
                              child: Text(c['label']!,
                                  style:
                                      TextStyle(color: appColors.textColor)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      final match = _currencies
                          .firstWhere((c) => c['code'] == val,
                              orElse: () => _currencies.first);
                      setState(() {
                        _config = _config.copyWith(
                          currency: match['code'],
                          currencySymbol: match['symbol'],
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingM),

            // ── Line Item Columns ──────────────────────────────────────
            _SectionHeader(title: 'Line Item Columns'),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Drag to reorder • Toggle visibility • Add custom columns',
                    style: TextStyle(
                      color: appColors.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacingM),
                  InvoiceColumnEditor(
                    columns: _config.lineItemColumns,
                    onChanged: (updated) {
                      setState(() {
                        _config =
                            _config.copyWith(lineItemColumns: updated);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingM),

            // ── Tax ───────────────────────────────────────────────────
            _SectionHeader(title: 'Tax'),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildToggleRow(
                    label: 'Enable Tax',
                    value: _config.taxEnabled,
                    onChanged: (v) =>
                        setState(() => _config = _config.copyWith(taxEnabled: v)),
                  ),
                  if (_config.taxEnabled) ...[
                    _buildDividerLine(),
                    const SizedBox(height: AppSpacing.spacingM),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Tax Label'),
                              const SizedBox(height: AppSpacing.spacingS),
                              _buildTextField(
                                  controller: _taxLabelController,
                                  hint: 'GST / VAT / Tax'),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Rate (%)'),
                              const SizedBox(height: AppSpacing.spacingS),
                              _buildTextField(
                                controller: _taxRateController,
                                hint: '0',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*')),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.spacingM),
                    _buildLabel('Tax Calculation'),
                    const SizedBox(height: AppSpacing.spacingS),
                    _buildSegmentedRow(
                      options: const ['Exclusive (added on top)', 'Inclusive (already in price)'],
                      selectedIndex: _config.taxIsInclusive ? 1 : 0,
                      onChanged: (i) => setState(() => _config =
                          _config.copyWith(taxIsInclusive: i == 1)),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingM),

            // ── Discount ──────────────────────────────────────────────
            _SectionHeader(title: 'Discount'),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildToggleRow(
                    label: 'Enable Discount Field',
                    value: _config.discountEnabled,
                    onChanged: (v) => setState(
                        () => _config = _config.copyWith(discountEnabled: v)),
                  ),
                  if (_config.discountEnabled) ...[
                    _buildDividerLine(),
                    const SizedBox(height: AppSpacing.spacingM),
                    _buildLabel('Discount Type'),
                    const SizedBox(height: AppSpacing.spacingS),
                    _buildSegmentedRow(
                      options: const ['Percentage (%)', 'Fixed Amount'],
                      selectedIndex:
                          _config.discountType == 'percentage' ? 0 : 1,
                      onChanged: (i) => setState(() => _config = _config
                          .copyWith(
                              discountType:
                                  i == 0 ? 'percentage' : 'fixed')),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingM),

            // ── Shipping / Extra Charges ───────────────────────────────
            _SectionHeader(title: 'Shipping & Extra Charges'),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildToggleRow(
                    label: 'Enable Shipping Field',
                    value: _config.shippingEnabled,
                    onChanged: (v) => setState(
                        () => _config = _config.copyWith(shippingEnabled: v)),
                  ),
                  if (_config.shippingEnabled) ...[
                    _buildDividerLine(),
                    const SizedBox(height: AppSpacing.spacingM),
                    _buildLabel('Field Label'),
                    const SizedBox(height: AppSpacing.spacingS),
                    _buildTextField(
                      controller: _shippingLabelController,
                      hint: 'Shipping & Handling',
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingM),

            // ── Due Date ──────────────────────────────────────────────
            _SectionHeader(title: 'Due Date'),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Due Date Type'),
                  const SizedBox(height: AppSpacing.spacingS),
                  _buildDropdown<String>(
                    value: _config.dueDateType,
                    items: const [
                      DropdownMenuItem(
                          value: 'net_days',
                          child: Text('Net Days (e.g. Net 30)')),
                      DropdownMenuItem(
                          value: 'specific_date',
                          child: Text('Pick a Specific Date')),
                      DropdownMenuItem(
                          value: 'none', child: Text('No Due Date')),
                    ],
                    onChanged: (val) => setState(
                        () => _config = _config.copyWith(dueDateType: val!)),
                  ),
                  if (_config.dueDateType == 'net_days') ...[
                    const SizedBox(height: AppSpacing.spacingM),
                    _buildLabel('Net Days'),
                    const SizedBox(height: AppSpacing.spacingS),
                    _buildTextField(
                      controller: _netDaysController,
                      hint: '30',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingM),

            // ── Notes & Terms ─────────────────────────────────────────
            _SectionHeader(title: 'Notes & Terms'),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildToggleRow(
                    label: 'Show Notes Field',
                    value: _config.showNotesField,
                    onChanged: (v) => setState(
                        () => _config = _config.copyWith(showNotesField: v)),
                  ),
                  if (_config.showNotesField) ...[
                    _buildDividerLine(),
                    const SizedBox(height: AppSpacing.spacingM),
                    _buildLabel('Default Notes'),
                    const SizedBox(height: AppSpacing.spacingS),
                    _buildTextField(
                      controller: _defaultNotesController,
                      hint: 'Thank you for your business!',
                      maxLines: 3,
                    ),
                  ],
                  _buildDividerLine(),
                  _buildToggleRow(
                    label: 'Show Terms & Conditions Field',
                    value: _config.showTermsField,
                    onChanged: (v) => setState(
                        () => _config = _config.copyWith(showTermsField: v)),
                  ),
                  if (_config.showTermsField) ...[
                    _buildDividerLine(),
                    const SizedBox(height: AppSpacing.spacingM),
                    _buildLabel('Default Terms'),
                    const SizedBox(height: AppSpacing.spacingS),
                    _buildTextField(
                      controller: _defaultTermsController,
                      hint: 'Payment is due within 30 days...',
                      maxLines: 3,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacingXL),

            // ── Save Button ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: AppSpacing.buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: AppRadius.medium),
                  elevation: 0,
                ),
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacingXL),
          ],
        ),
      ),
    );
  }

  // ── Shared UI helpers ────────────────────────────────────────────────

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: appColors.textSecondaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      onChanged: onChanged,
      style: TextStyle(color: appColors.textColor, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            TextStyle(color: appColors.textSecondaryColor.withValues(alpha: 0.6)),
        filled: true,
        fillColor: appColors.borderColor.withValues(alpha: 0.2),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide: BorderSide(color: appColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.medium,
          borderSide:
              BorderSide(color: appColors.primaryColor, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Switch.adaptive(
          value: value,
          activeTrackColor: appColors.primaryColor.withValues(alpha: 0.5),
          activeThumbColor: appColors.primaryColor,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: AppRadius.medium,
        border: Border.all(color: appColors.borderColor),
        color: appColors.borderColor.withValues(alpha: 0.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down,
              color: appColors.textSecondaryColor),
          dropdownColor: appColors.backgroundColor,
          style: TextStyle(color: appColors.textColor, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSegmentedRow({
    required List<String> options,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: options.asMap().entries.map((entry) {
        final isSelected = entry.key == selectedIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(entry.key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: entry.key < options.length - 1 ? 6 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? appColors.primaryColor
                    : appColors.borderColor.withValues(alpha: 0.25),
                borderRadius: AppRadius.medium,
                border: Border.all(
                  color: isSelected
                      ? appColors.primaryColor
                      : appColors.borderColor,
                ),
              ),
              child: Text(
                entry.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : appColors.textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDividerLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: appColors.borderColor, height: 1),
    );
  }
}

// ── Reusable layout widgets ──────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title.toUpperCase(),
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

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
