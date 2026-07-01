import 'package:cloud_billr/helpers/database_helper.dart';
import 'package:cloud_billr/models/company_model.dart';
import 'package:flutter/material.dart';

class CompanyProvider extends ChangeNotifier {
  final List<CompanyModel> _companies = [];

  List<CompanyModel> get companies => List.unmodifiable(_companies);

  CompanyProvider() {
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    await _seedMockDataIfEmpty();
    await loadCompanies();
  }

  Future<void> loadCompanies() async {
    try {
      final data = await DatabaseHelper.instance.queryAllCompanies();
      _companies.clear();
      _companies.addAll(data.map((map) => CompanyModel.fromMap(map)));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading companies: $e');
    }
  }

  Future<void> _seedMockDataIfEmpty() async {
    try {
      final existing = await DatabaseHelper.instance.queryAllCompanies();
      if (existing.isEmpty) {
        // Seed default profiles
        final defaults = [
          CompanyModel(
            id: '1',
            name: 'Acme Corp',
            address: '123 Enterprise Way, Suite 500, New York, NY 10001',
            contactDetails: 'info@acme.corp | +1 (555) 019-2831',
          ),
          CompanyModel(
            id: '2',
            name: 'Nova Solutions',
            address: '789 Innovation Drive, Austin, TX 78701',
            contactDetails: 'hello@novasolutions.io | +1 (555) 022-8819',
          ),
        ];

        for (var company in defaults) {
          await DatabaseHelper.instance.insertCompany(company.toMap());
        }
      }
    } catch (e) {
      debugPrint('Error seeding default company data: $e');
    }
  }

  Future<void> addCompany(CompanyModel company) async {
    try {
      await DatabaseHelper.instance.insertCompany(company.toMap());
      await loadCompanies();
    } catch (e) {
      debugPrint('Error adding company: $e');
    }
  }

  Future<void> updateCompany(CompanyModel updatedCompany) async {
    try {
      await DatabaseHelper.instance.updateCompany(updatedCompany.toMap());
      await loadCompanies();
    } catch (e) {
      debugPrint('Error updating company: $e');
    }
  }

  Future<void> removeCompany(String id) async {
    try {
      await DatabaseHelper.instance.deleteCompany(id);
      await loadCompanies();
    } catch (e) {
      debugPrint('Error removing company: $e');
    }
  }
}
