// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_billr/database/migrations.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main(List<String> args) async {
  print('=============================================');
  print('          Cloud-Billr DB Migrations          ');
  print('=============================================');

  final command = args.isNotEmpty ? args[0] : 'status';

  if (command == 'help' || command == '--help' || command == '-h') {
    print('Usage: dart run bin/migrate.dart [command]');
    print('\nAvailable commands:');
    print('  status   - Shows the list of migrations defined in migrations.dart (Default)');
    print('  test     - Simulates applying all migrations on an in-memory SQLite database');
    print('  apply    - Applies all migrations to a local database file (cloud_billr_dev.db)');
    print('  help     - Shows this help message');
    return;
  }

  // Initialize FFI for local SQLite execution
  sqfliteFfiInit();
  final databaseFactory = databaseFactoryFfi;

  if (command == 'status') {
    print('Total migrations defined: ${databaseMigrations.length}\n');
    for (int i = 0; i < databaseMigrations.length; i++) {
      print('Migration Version ${i + 1}:');
      print('---------------------------------------------');
      print(databaseMigrations[i].trim());
      print('---------------------------------------------\n');
    }
  } else if (command == 'test') {
    print('Running migrations on an in-memory SQLite database (Dry Run)...');
    try {
      final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
      
      print('Database opened. Applying migrations sequentially:');
      for (int i = 0; i < databaseMigrations.length; i++) {
        print(' -> Applying Version ${i + 1}...');
        await db.execute(databaseMigrations[i]);
      }
      
      print('\nSuccess: All ${databaseMigrations.length} migrations applied successfully with zero errors!');
      await db.close();
    } catch (e) {
      print('\n[ERROR] Migration test failed:');
      print(e);
      exit(1);
    }
  } else if (command == 'apply') {
    final dbFile = 'cloud_billr_dev.db';
    print('Applying migrations to local file database ($dbFile)...');
    try {
      // Delete existing to start fresh for development/test
      final file = File(dbFile);
      if (await file.exists()) {
        await file.delete();
        print('Deleted existing $dbFile to run clean migration.');
      }

      final db = await databaseFactory.openDatabase(dbFile);
      
      for (int i = 0; i < databaseMigrations.length; i++) {
        print(' -> Applying Version ${i + 1}...');
        await db.execute(databaseMigrations[i]);
      }
      
      print('\nSuccess: All migrations applied successfully to local $dbFile!');
      await db.close();
    } catch (e) {
      print('\n[ERROR] Migration execution failed:');
      print(e);
      exit(1);
    }
  } else {
    print('Unknown command "$command". Use "help" to see list of commands.');
  }
}
