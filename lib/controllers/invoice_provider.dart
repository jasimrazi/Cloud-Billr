import 'package:cloud_billr/helpers/database_helper.dart';
import 'package:cloud_billr/models/invoice_model.dart';
import 'package:flutter/material.dart';

class InvoiceProvider extends ChangeNotifier {
  final List<InvoiceModel> _invoices = [];

  List<InvoiceModel> get invoices => List.unmodifiable(_invoices);

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
          ),
          InvoiceModel(
            id: '2',
            invoiceNumber: 'INV-2024-002',
            clientName: 'Design Studio Co',
            status: 'Pending',
            amount: '\$1,800.00',
            date: 'Jan 14, 2024',
          ),
          InvoiceModel(
            id: '3',
            invoiceNumber: 'INV-2024-003',
            clientName: 'Marketing Pro Ltd',
            status: 'Paid',
            amount: '\$3,200.00',
            date: 'Jan 13, 2024',
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

  Future<void> deleteInvoice(String id) async {
    try {
      await DatabaseHelper.instance.deleteInvoice(id);
      await loadInvoices();
    } catch (e) {
      debugPrint('Error deleting invoice: $e');
    }
  }
}
