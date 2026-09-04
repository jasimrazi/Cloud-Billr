const String migrationV9 = '''
  CREATE TABLE users (
    id TEXT PRIMARY KEY,
    name TEXT,
    email TEXT UNIQUE,
    phone TEXT,
    company_name TEXT,
    website_link TEXT
  );

  CREATE TABLE photos (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    photo_path TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
  );
''';