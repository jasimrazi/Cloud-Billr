import 'dart:convert';

class InvoiceColumnConfig {
  final String id;
  final String label;
  final String fieldType; // "text" | "number" | "calculated"
  final bool isRequired;
  final bool isVisible;
  final int sortOrder;

  const InvoiceColumnConfig({
    required this.id,
    required this.label,
    required this.fieldType,
    required this.isRequired,
    required this.isVisible,
    required this.sortOrder,
  });

  InvoiceColumnConfig copyWith({
    String? id,
    String? label,
    String? fieldType,
    bool? isRequired,
    bool? isVisible,
    int? sortOrder,
  }) {
    return InvoiceColumnConfig(
      id: id ?? this.id,
      label: label ?? this.label,
      fieldType: fieldType ?? this.fieldType,
      isRequired: isRequired ?? this.isRequired,
      isVisible: isVisible ?? this.isVisible,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'field_type': fieldType,
      'is_required': isRequired,
      'is_visible': isVisible,
      'sort_order': sortOrder,
    };
  }

  factory InvoiceColumnConfig.fromMap(Map<String, dynamic> map) {
    return InvoiceColumnConfig(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      fieldType: map['field_type'] ?? 'text',
      isRequired: map['is_required'] ?? false,
      isVisible: map['is_visible'] ?? true,
      sortOrder: map['sort_order'] ?? 0,
    );
  }
}

class InvoiceTemplateConfig {
  final String id;

  // Numbering
  final String invoiceNumberFormat;
  final int invoiceNumberStartAt;

  // Currency
  final String currency;
  final String currencySymbol;

  // Tax
  final bool taxEnabled;
  final String taxLabel;
  final double taxRate;
  final bool taxIsInclusive;

  // Discount
  final bool discountEnabled;
  final String discountType; // "percentage" | "fixed"

  // Shipping
  final bool shippingEnabled;
  final String shippingLabel;

  // Due date
  final String dueDateType; // "net_days" | "specific_date" | "none"
  final int netDays;

  // Notes & Terms
  final bool showNotesField;
  final bool showTermsField;
  final String defaultNotes;
  final String defaultTerms;

  // Line item columns
  final List<InvoiceColumnConfig> lineItemColumns;

  final int defaultTemplateIndex;

  const InvoiceTemplateConfig({
    required this.id,
    required this.invoiceNumberFormat,
    required this.invoiceNumberStartAt,
    required this.currency,
    required this.currencySymbol,
    required this.taxEnabled,
    required this.taxLabel,
    required this.taxRate,
    required this.taxIsInclusive,
    required this.discountEnabled,
    required this.discountType,
    required this.shippingEnabled,
    required this.shippingLabel,
    required this.dueDateType,
    required this.netDays,
    required this.showNotesField,
    required this.showTermsField,
    required this.defaultNotes,
    required this.defaultTerms,
    required this.lineItemColumns,
    this.defaultTemplateIndex = 0,
  });

  static InvoiceTemplateConfig get defaults => InvoiceTemplateConfig(
        id: 'default',
        invoiceNumberFormat: 'INV-{YEAR}-{SEQ}',
        invoiceNumberStartAt: 1,
        currency: 'USD',
        currencySymbol: '\$',
        taxEnabled: true,
        taxLabel: 'Tax',
        taxRate: 0.0,
        taxIsInclusive: false,
        discountEnabled: false,
        discountType: 'percentage',
        shippingEnabled: false,
        shippingLabel: 'Shipping & Handling',
        dueDateType: 'net_days',
        netDays: 30,
        showNotesField: true,
        showTermsField: true,
        defaultNotes: '',
        defaultTerms: '',
        defaultTemplateIndex: 0,
        lineItemColumns: [
          InvoiceColumnConfig(
            id: 'description',
            label: 'Description',
            fieldType: 'text',
            isRequired: true,
            isVisible: true,
            sortOrder: 0,
          ),
          InvoiceColumnConfig(
            id: 'quantity',
            label: 'Qty',
            fieldType: 'number',
            isRequired: true,
            isVisible: true,
            sortOrder: 1,
          ),
          InvoiceColumnConfig(
            id: 'unit_price',
            label: 'Unit Price',
            fieldType: 'number',
            isRequired: true,
            isVisible: true,
            sortOrder: 2,
          ),
          InvoiceColumnConfig(
            id: 'amount',
            label: 'Amount',
            fieldType: 'calculated',
            isRequired: true,
            isVisible: true,
            sortOrder: 3,
          ),
        ],
      );

  InvoiceTemplateConfig copyWith({
    String? id,
    String? invoiceNumberFormat,
    int? invoiceNumberStartAt,
    String? currency,
    String? currencySymbol,
    bool? taxEnabled,
    String? taxLabel,
    double? taxRate,
    bool? taxIsInclusive,
    bool? discountEnabled,
    String? discountType,
    bool? shippingEnabled,
    String? shippingLabel,
    String? dueDateType,
    int? netDays,
    bool? showNotesField,
    bool? showTermsField,
    String? defaultNotes,
    String? defaultTerms,
    List<InvoiceColumnConfig>? lineItemColumns,
    int? defaultTemplateIndex,
  }) {
    return InvoiceTemplateConfig(
      id: id ?? this.id,
      invoiceNumberFormat: invoiceNumberFormat ?? this.invoiceNumberFormat,
      invoiceNumberStartAt: invoiceNumberStartAt ?? this.invoiceNumberStartAt,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      taxEnabled: taxEnabled ?? this.taxEnabled,
      taxLabel: taxLabel ?? this.taxLabel,
      taxRate: taxRate ?? this.taxRate,
      taxIsInclusive: taxIsInclusive ?? this.taxIsInclusive,
      discountEnabled: discountEnabled ?? this.discountEnabled,
      discountType: discountType ?? this.discountType,
      shippingEnabled: shippingEnabled ?? this.shippingEnabled,
      shippingLabel: shippingLabel ?? this.shippingLabel,
      dueDateType: dueDateType ?? this.dueDateType,
      netDays: netDays ?? this.netDays,
      showNotesField: showNotesField ?? this.showNotesField,
      showTermsField: showTermsField ?? this.showTermsField,
      defaultNotes: defaultNotes ?? this.defaultNotes,
      defaultTerms: defaultTerms ?? this.defaultTerms,
      lineItemColumns: lineItemColumns ?? this.lineItemColumns,
      defaultTemplateIndex: defaultTemplateIndex ?? this.defaultTemplateIndex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoice_number_format': invoiceNumberFormat,
      'invoice_number_start_at': invoiceNumberStartAt,
      'currency': currency,
      'currency_symbol': currencySymbol,
      'tax_enabled': taxEnabled ? 1 : 0,
      'tax_label': taxLabel,
      'tax_rate': taxRate,
      'tax_is_inclusive': taxIsInclusive ? 1 : 0,
      'discount_enabled': discountEnabled ? 1 : 0,
      'discount_type': discountType,
      'shipping_enabled': shippingEnabled ? 1 : 0,
      'shipping_label': shippingLabel,
      'due_date_type': dueDateType,
      'net_days': netDays,
      'show_notes_field': showNotesField ? 1 : 0,
      'show_terms_field': showTermsField ? 1 : 0,
      'default_notes': defaultNotes,
      'default_terms': defaultTerms,
      'default_template_index': defaultTemplateIndex,
      'line_item_columns':
          jsonEncode(lineItemColumns.map((c) => c.toMap()).toList()),
    };
  }

  factory InvoiceTemplateConfig.fromMap(Map<String, dynamic> map) {
    List<InvoiceColumnConfig> columns = [];
    try {
      final decoded = jsonDecode(map['line_item_columns'] ?? '[]') as List;
      columns = decoded
          .map((e) => InvoiceColumnConfig.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      columns = InvoiceTemplateConfig.defaults.lineItemColumns;
    }

    return InvoiceTemplateConfig(
      id: map['id'] ?? 'default',
      invoiceNumberFormat:
          map['invoice_number_format'] ?? 'INV-{YEAR}-{SEQ}',
      invoiceNumberStartAt: map['invoice_number_start_at'] ?? 1,
      currency: map['currency'] ?? 'USD',
      currencySymbol: map['currency_symbol'] ?? '\$',
      taxEnabled: (map['tax_enabled'] ?? 1) == 1,
      taxLabel: map['tax_label'] ?? 'Tax',
      taxRate: (map['tax_rate'] ?? 0.0).toDouble(),
      taxIsInclusive: (map['tax_is_inclusive'] ?? 0) == 1,
      discountEnabled: (map['discount_enabled'] ?? 0) == 1,
      discountType: map['discount_type'] ?? 'percentage',
      shippingEnabled: (map['shipping_enabled'] ?? 0) == 1,
      shippingLabel: map['shipping_label'] ?? 'Shipping & Handling',
      dueDateType: map['due_date_type'] ?? 'net_days',
      netDays: map['net_days'] ?? 30,
      showNotesField: (map['show_notes_field'] ?? 1) == 1,
      showTermsField: (map['show_terms_field'] ?? 1) == 1,
      defaultNotes: map['default_notes'] ?? '',
      defaultTerms: map['default_terms'] ?? '',
      lineItemColumns: columns,
      defaultTemplateIndex: map['default_template_index'] ?? 0,
    );
  }
}
