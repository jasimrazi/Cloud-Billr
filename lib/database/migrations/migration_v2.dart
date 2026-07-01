const String migrationV2 = '''
CREATE TABLE invoices (
  id TEXT PRIMARY KEY,
  invoice_number TEXT NOT NULL,
  client_name TEXT NOT NULL,
  status TEXT NOT NULL,
  amount TEXT NOT NULL,
  date TEXT NOT NULL
);
''';
