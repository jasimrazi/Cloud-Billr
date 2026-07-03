import 'package:cloud_billr/database/migrations.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cloud_billr.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: databaseMigrations.length,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    for (int i = 0; i < version; i++) {
      await db.execute(databaseMigrations[i]);
    }
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    for (int i = oldVersion; i < newVersion; i++) {
      await db.execute(databaseMigrations[i]);
    }
  }

  // --- CRUD HELPERS FOR COMPANIES ---
  
  Future<int> insertCompany(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('companies', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllCompanies() async {
    final db = await instance.database;
    return await db.query('companies');
  }

  Future<int> updateCompany(Map<String, dynamic> row) async {
    final db = await instance.database;
    final String id = row['id'];
    return await db.update('companies', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCompany(String id) async {
    final db = await instance.database;
    return await db.delete('companies', where: 'id = ?', whereArgs: [id]);
  }

  // --- CRUD HELPERS FOR CUSTOMERS ---

  Future<int> insertCustomer(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('customers', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllCustomers() async {
    final db = await instance.database;
    return await db.query('customers');
  }

  Future<int> updateCustomer(Map<String, dynamic> row) async {
    final db = await instance.database;
    final String id = row['id'];
    return await db.update('customers', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCustomer(String id) async {
    final db = await instance.database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  // --- CRUD HELPERS FOR INVOICES ---

  Future<int> insertInvoice(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('invoices', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllInvoices() async {
    final db = await instance.database;
    return await db.query('invoices');
  }

  Future<int> deleteInvoice(String id) async {
    final db = await instance.database;
    return await db.delete('invoices', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }

  // --- CRUD HELPERS FOR INVOICE TEMPLATE CONFIG ---

  Future<int> insertOrReplaceConfig(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('invoice_template_configs', row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> queryConfig() async {
    final db = await instance.database;
    final results = await db.query('invoice_template_configs', limit: 1);
    return results.isNotEmpty ? results.first : null;
  }
}

