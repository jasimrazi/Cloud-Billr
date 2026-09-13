const String migrationV11 = '''
  CREATE TABLE photos (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    photo_path TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
  );
''';