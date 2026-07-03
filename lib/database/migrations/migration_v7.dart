const String migrationV7 = '''
ALTER TABLE invoices ADD COLUMN total_amount REAL NOT NULL DEFAULT 0;
''';
