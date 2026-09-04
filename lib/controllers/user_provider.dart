import 'package:cloud_billr/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{

  Future<void> saveProfile(UserModel user) async {
    try {
      // await DatabaseHelper.instance.insertCustomer(customer.toMap());
      // await loadCustomers();
    } catch (e) {
      debugPrint('Error adding customer: $e');
    }
  }
}