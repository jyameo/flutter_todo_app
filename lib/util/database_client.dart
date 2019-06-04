import 'dart:async';
import 'dart:io';

import 'package:flutter_notodo/model/notodo_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String tableName = "nodoTbl";
  final String columnId = "id";
  final String columnItemName = "itemName";
  final String columnDateCreated = "dateCreated";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "notodo.db");

    var _db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(""
        "Create Table $tableName("
        "$columnId INTEGER PRIMARY KEY, "
        "$columnItemName TEXT, "
        "$columnDateCreated TEXT)");
  }

  //Create
  Future<int> saveItem(NotodoItem item) async {
    var dbClient = await db;
    int res = await dbClient.insert('$tableName', item.toMap());
    return res;
  }

  Future<List> getItems() async {
    var dbClient = await db;
    var res = await dbClient
        .rawQuery("SELECT * FROM $tableName ORDER BY $columnItemName ASC");
    return res;
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(""
        "SELECT COUNT(*) FROM $tableName"));
  }

  Future<NotodoItem> getItem(int id) async {
    var dbClient = await db;

    var res = await dbClient.rawQuery(""
        "SELECT * FROM $tableName "
        "WHERE $columnId = $id");
    if (res.length == 0) return null;

    return new NotodoItem.fromMap(res.first);
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateItem(NotodoItem item) async {
    var dbClient = await db;
    return dbClient.update(tableName, item.toMap(),
        where: "$columnId = ?", whereArgs: [item.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
