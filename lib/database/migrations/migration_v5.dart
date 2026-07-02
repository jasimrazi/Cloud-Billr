const String migrationV5 = '''
CREATE TABLE customers (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  address TEXT,
  phone TEXT
);
''';
