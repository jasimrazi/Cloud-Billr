const String migrationV8 = '''
ALTER TABLE invoices ADD COLUMN template_index INTEGER NOT NULL DEFAULT 0;
ALTER TABLE invoice_template_configs ADD COLUMN default_template_index INTEGER NOT NULL DEFAULT 0;
''';
