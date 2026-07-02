import 'package:cloud_billr/helpers/database_helper.dart';
import 'package:cloud_billr/models/customer_model.dart';
import 'package:flutter/material.dart';

class CustomerProvider extends ChangeNotifier {
  final List<CustomerModel> _customers = [];

  List<CustomerModel> get customers => List.unmodifiable(_customers);

  CustomerProvider() {
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    await _seedMockDataIfEmpty();
    await loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {
      final data = await DatabaseHelper.instance.queryAllCustomers();
      _customers.clear();
      _customers.addAll(data.map((map) => CustomerModel.fromMap(map)));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading customers: $e');
    }
  }

  Future<void> _seedMockDataIfEmpty() async {
    try {
      final existing = await DatabaseHelper.instance.queryAllCustomers();
      if (existing.isEmpty) {
        // Seed default profiles
        final defaults = [
          CustomerModel(
            id: '1',
            name: 'John Doe',
            email: 'john.doe@example.com',
            address: '456 Elm Street, Springfield, IL 62701',
            phone: '+1 (555) 123-4567',
          ),
          CustomerModel(
            id: '2',
            name: 'Jane Smith',
            email: 'jane.smith@example.com',
            address: '789 Oak Ave, Riverdale, NY 10471',
            phone: '+1 (555) 987-6543',
          ),
        ];

        for (var customer in defaults) {
          await DatabaseHelper.instance.insertCustomer(customer.toMap());
        }
      }
    } catch (e) {
      debugPrint('Error seeding default customer data: $e');
    }
  }

  Future<void> addCustomer(CustomerModel customer) async {
    try {
      await DatabaseHelper.instance.insertCustomer(customer.toMap());
      await loadCustomers();
    } catch (e) {
      debugPrint('Error adding customer: $e');
    }
  }

  Future<void> updateCustomer(CustomerModel updatedCustomer) async {
    try {
      await DatabaseHelper.instance.updateCustomer(updatedCustomer.toMap());
      await loadCustomers();
    } catch (e) {
      debugPrint('Error updating customer: $e');
    }
  }

  Future<void> removeCustomer(String id) async {
    try {
      await DatabaseHelper.instance.deleteCustomer(id);
      await loadCustomers();
    } catch (e) {
      debugPrint('Error removing customer: $e');
    }
  }
}
