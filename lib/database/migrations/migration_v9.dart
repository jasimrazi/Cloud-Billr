const String migrationV9 = '''
  CREATE TABLE users (
    id TEXT PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE,
    phone TEXT,
    company_name TEXT,
    website_link TEXT
  );
''';