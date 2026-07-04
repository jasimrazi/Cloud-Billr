import 'package:cloud_billr/database/migrations/migration_v1.dart';
import 'package:cloud_billr/database/migrations/migration_v2.dart';
import 'package:cloud_billr/database/migrations/migration_v3.dart';
import 'package:cloud_billr/database/migrations/migration_v4.dart';
import 'package:cloud_billr/database/migrations/migration_v5.dart';
import 'package:cloud_billr/database/migrations/migration_v6.dart';
import 'package:cloud_billr/database/migrations/migration_v7.dart';
import 'package:cloud_billr/database/migrations/migration_v8.dart';

/// A list of SQL migration statements that need to be run when the app is installed
/// or upgraded. Each migration is defined in its own file under the database/migrations/ folder.
const List<String> databaseMigrations = [
  migrationV1,
  migrationV2,
  migrationV3,
  migrationV4,
  migrationV5,
  migrationV6,
  migrationV7,
  migrationV8,
];

