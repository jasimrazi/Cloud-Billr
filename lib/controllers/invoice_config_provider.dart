import 'package:cloud_billr/helpers/database_helper.dart';
import 'package:cloud_billr/models/invoice_template_config_model.dart';
import 'package:flutter/material.dart';

class InvoiceConfigProvider extends ChangeNotifier {
  InvoiceTemplateConfig _config = InvoiceTemplateConfig.defaults;

  InvoiceTemplateConfig get config => _config;

  InvoiceConfigProvider() {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final data = await DatabaseHelper.instance.queryConfig();
      if (data != null) {
        _config = InvoiceTemplateConfig.fromMap(data);
      } else {
        // Seed with defaults on first launch
        await DatabaseHelper.instance
            .insertOrReplaceConfig(_config.toMap());
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading invoice config: $e');
    }
  }

  Future<void> saveConfig(InvoiceTemplateConfig config) async {
    try {
      await DatabaseHelper.instance.insertOrReplaceConfig(config.toMap());
      _config = config;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving invoice config: $e');
    }
  }

  Future<void> resetToDefaults() async {
    await saveConfig(InvoiceTemplateConfig.defaults);
  }
}
