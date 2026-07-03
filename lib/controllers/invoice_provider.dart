import 'package:cloud_billr/helpers/database_helper.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:flutter/material.dart';

class InvoiceProvider extends ChangeNotifier {
  final List<InvoiceModel> _invoices = [];

  List<InvoiceModel> get invoices => List.unmodifiable(_invoices);

  double get totalRevenue => _invoices
      .where((i) => i.status.toLowerCase() == 'paid')
      .fold(0.0, (sum, i) => sum + i.totalAmount);

  double get pendingAmount => _invoices
      .where((i) => i.status.toLowerCase() == 'pending')
      .fold(0.0, (sum, i) => sum + i.totalAmount);

  InvoiceProvider() {
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    await _seedMockDataIfEmpty();
    await loadInvoices();
  }

  Future<void> loadInvoices() async {
    try {
      final data = await DatabaseHelper.instance.queryAllInvoices();
      _invoices.clear();
      _invoices.addAll(data.map((map) => InvoiceModel.fromMap(map)));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading invoices: $e');
    }
  }

  Future<void> _seedMockDataIfEmpty() async {
    try {
      final existing = await DatabaseHelper.instance.queryAllInvoices();
      if (existing.isEmpty) {
        final defaults = [
          InvoiceModel(
            id: '1',
            invoiceNumber: 'INV-2024-001',
            clientName: 'Tech Solutions Inc',
            status: 'Paid',
            amount: '\$2,500.00',
            date: 'Jan 15, 2025',
            totalAmount: 2500.0,
          ),
          InvoiceModel(
            id: '2',
            invoiceNumber: 'INV-2024-002',
            clientName: 'Design Studio Co',
            status: 'Pending',
            amount: '\$1,800.00',
            date: 'Jan 14, 2024',
            totalAmount: 1800.0,
          ),
          InvoiceModel(
            id: '3',
            invoiceNumber: 'INV-2024-003',
            clientName: 'Marketing Pro Ltd',
            status: 'Paid',
            amount: '\$3,200.00',
            date: 'Jan 13, 2024',
            totalAmount: 3200.0,
          ),
        ];

        for (var invoice in defaults) {
          await DatabaseHelper.instance.insertInvoice(invoice.toMap());
        }
      }
    } catch (e) {
      debugPrint('Error seeding default invoices: $e');
    }
  }

  Future<void> addInvoice(InvoiceModel invoice) async {
    try {
      await DatabaseHelper.instance.insertInvoice(invoice.toMap());
      await loadInvoices();
    } catch (e) {
      debugPrint('Error adding invoice: $e');
    }
  }

  Future<void> updateInvoiceStatus(String id, String status) async {
    try {
      await DatabaseHelper.instance.updateInvoiceStatus(id, status);
      final index = _invoices.indexWhere((i) => i.id == id);
      if (index != -1) {
        _invoices[index] = _invoices[index].copyWith(status: status);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating invoice status: $e');
    }
  }

  Future<void> deleteInvoice(String id) async {
    try {
      await DatabaseHelper.instance.deleteInvoice(id);
      await loadInvoices();
    } catch (e) {
      debugPrint('Error deleting invoice: $e');
    }
  }

  /// Generates an invoice number from a format string.
  /// Supported tokens: {YEAR}, {MONTH}, {SEQ}
  String generateInvoiceNumber(String format, int seq) {
    final now = DateTime.now();
    return format
        .replaceAll('{YEAR}', now.year.toString())
        .replaceAll('{MONTH}', now.month.toString().padLeft(2, '0'))
        .replaceAll('{SEQ}', seq.toString().padLeft(3, '0'));
  }

  int get nextSequenceNumber {
    if (_invoices.isEmpty) return 1;
    return _invoices.length + 1;
  }
}
