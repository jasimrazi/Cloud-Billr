import 'package:cloud_billr/models/company_model.dart';
import 'package:flutter/material.dart';

class CompanyProvider extends ChangeNotifier {
  final List<CompanyModel> _companies = [
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

  List<CompanyModel> get companies => List.unmodifiable(_companies);

  void addCompany(CompanyModel company) {
    _companies.add(company);
    notifyListeners();
  }

  void updateCompany(CompanyModel updatedCompany) {
    final index = _companies.indexWhere((c) => c.id == updatedCompany.id);
    if (index != -1) {
      _companies[index] = updatedCompany;
      notifyListeners();
    }
  }

  void removeCompany(String id) {
    _companies.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
