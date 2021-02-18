import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class UserDatabaseHelper {
  final String tableName = "user";

  final String columnId = "id";
  final String columnName = "name";
  final String columnPhone = "phone";

  static final UserDatabaseHelper _instance = new UserDatabaseHelper.internal();

  UserDatabaseHelper.internal();
  factory UserDatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    var documentDirectory = await getDatabasesPath();
    String path = join(documentDirectory, "mosque.db");
    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnPhone TEXT)",
    );
  }

  //CRUD Operations - Create, Read, Update, Delete

  // Save user info in database
  Future<int> saveUserInfo(String name, String phone) async {
    var dbClient = await db;
    List<Map> result =
        await dbClient.rawQuery("SELECT * FROM $tableName WHERE $columnId = 1");
    if (result.isNotEmpty) {
      print('updating name');
      await dbClient.rawUpdate(
        'UPDATE $tableName SET $columnName = ?, $columnPhone =? WHERE $columnId = ?',
        [name, phone, 1],
      );
    } else {
      print('inserting name');
      int insertedId = await dbClient.rawInsert(
        'INSERT INTO $tableName($columnId, $columnName, $columnPhone) VALUES(?,?,?)',
        [1, name, phone],
      );
      print(insertedId);
      return insertedId;
    }
    return null;
  }

  // Get saved user info from database
  Future<List<Map>> getUserInfo() async {
    var dbClient = await db;
    List<Map> result = await dbClient
        .rawQuery("SELECT * FROM $tableName WHERE $columnId == 1");
    return result;
  }

  // Closes the database when done, because it uses resources in background.
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
