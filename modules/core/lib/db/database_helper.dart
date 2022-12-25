import 'dart:async';
import 'dart:developer';
import 'package:core/commons/create_table_contract.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static DatabaseHelper? _databaseHelper;
  late List<CreateTableContract> _tableBuilder;

  DatabaseHelper._instance(List<CreateTableContract> tableBuilder) {
    _databaseHelper = this;
    _tableBuilder = tableBuilder;
  }

  factory DatabaseHelper({
    required List<CreateTableContract> tableBuilder,
  }) =>
      _databaseHelper ?? DatabaseHelper._instance(tableBuilder);

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  Future<void> mockDatabase(Database database) async {
    _database = database;
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    for (var tableContract in _tableBuilder) {
      log('Creating table ${tableContract.tableName}');
      await db.execute(tableContract.tableQuery);
    }
  }
}
