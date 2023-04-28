import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart' as dbPath;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_test_case/models/userModel.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final String _dbName = "testcase.db";
  final int _dbVersion = 1;

  DatabaseHelper.internal();
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get database async {
    if (_db != null) return _db;
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = dbPath.join(documentDirectory.path, _dbName);
    return _db = await openDatabase(path,
        version: _dbVersion, onCreate: _onDatabaseCreate);
  }

  FutureOr<void> _onDatabaseCreate(Database db, int version) async {
    await db.execute(UserModel.createTable);
  }

  saveReg(Map<String, dynamic> mapList) async {
    Database? db = await database;
    return await db!.insert("user", mapList);
  }

  Future<List<UserModel>> getMicroData() async {
    var db = await database;
    List<Map<String, dynamic>> resultMap = await db!.rawQuery('select * from user');
    return resultMap.map((f) => UserModel.fromMap(f)).toList();
  }
}