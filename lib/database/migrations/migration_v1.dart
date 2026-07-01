const String migrationV1 = '''
CREATE TABLE companies (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  address TEXT,
  contactDetails TEXT
);
''';
