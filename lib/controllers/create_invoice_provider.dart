import 'package:cloud_billr/models/customer_model.dart';
import 'package:flutter/material.dart';

class InvoiceItemDraft {
  final String id;
  String description;
  double quantity;
  double rate;

  InvoiceItemDraft({
    required this.id,
    this.description = '',
    this.quantity = 0,
    this.rate = 0,
  });

  double get lineTotal => quantity * rate;
}

class CreateInvoiceProvider extends ChangeNotifier {
  final List<InvoiceItemDraft> _items = [
    InvoiceItemDraft(id: _newId()),
  ];

  CustomerModel? _selectedCustomer;
  double _discountValue = 0;
  String _invoiceNumber = '';

  // Tax settings (populated from InvoiceConfigProvider before use)
  bool taxEnabled = false;
  String taxLabel = 'Tax';
  double taxRate = 0.0;
  bool taxIsInclusive = false;
  bool discountEnabled = false;
  String discountType = 'percentage';
  String currencySymbol = '\$';

  List<InvoiceItemDraft> get items => List.unmodifiable(_items);
  CustomerModel? get selectedCustomer => _selectedCustomer;
  double get discountValue => _discountValue;
  String get invoiceNumber => _invoiceNumber;

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.lineTotal);

  double get taxAmount {
    if (!taxEnabled) return 0;
    if (taxIsInclusive) {
      // Tax already included in price: tax = subtotal - (subtotal / (1 + rate/100))
      return subtotal - (subtotal / (1 + taxRate / 100));
    }
    return subtotal * (taxRate / 100);
  }

  double get discountAmount {
    if (!discountEnabled || _discountValue <= 0) return 0;
    if (discountType == 'percentage') {
      return subtotal * (_discountValue / 100);
    }
    return _discountValue;
  }

  double get grandTotal {
    final base = subtotal;
    final tax = taxIsInclusive ? 0.0 : taxAmount;
    return base + tax - discountAmount;
  }

  static String _newId() =>
      DateTime.now().microsecondsSinceEpoch.toString();

  void applyConfig({
    required bool taxEnabled,
    required String taxLabel,
    required double taxRate,
    required bool taxIsInclusive,
    required bool discountEnabled,
    required String discountType,
    required String currencySymbol,
  }) {
    this.taxEnabled = taxEnabled;
    this.taxLabel = taxLabel;
    this.taxRate = taxRate;
    this.taxIsInclusive = taxIsInclusive;
    this.discountEnabled = discountEnabled;
    this.discountType = discountType;
    this.currencySymbol = currencySymbol;
    notifyListeners();
  }

  void setInvoiceNumber(String number) {
    _invoiceNumber = number;
  }

  void setCustomer(CustomerModel? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  void addItem() {
    _items.add(InvoiceItemDraft(id: _newId()));
    notifyListeners();
  }

  void removeItem(int index) {
    if (_items.length <= 1) return;
    _items.removeAt(index);
    notifyListeners();
  }

  void updateItem(int index, {String? description, double? quantity, double? rate}) {
    if (index < 0 || index >= _items.length) return;
    final item = _items[index];
    if (description != null) item.description = description;
    if (quantity != null) item.quantity = quantity;
    if (rate != null) item.rate = rate;
    notifyListeners();
  }

  void setDiscount(double value) {
    _discountValue = value;
    notifyListeners();
  }

  void reset() {
    _items.clear();
    _items.add(InvoiceItemDraft(id: _newId()));
    _selectedCustomer = null;
    _discountValue = 0;
    _invoiceNumber = '';
    notifyListeners();
  }
}
