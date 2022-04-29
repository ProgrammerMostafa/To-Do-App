import 'package:flutter/foundation.dart';
import 'package:flutter_advanced_testing/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const int _version = 1;
  static const String _tableName = 'Tasks';
  static Database? _db;

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  static Future<void> initDB() async {
    if (_db != null) {
      print('sssss');
      return;
    }
    try {
      // Get a location using getDatabasesPath
      String _path = await getDatabasesPath() + 'tasks.db';

      // open the database
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (Database database, int version) async {
          // When creating the db, create the table
          await database.execute(
              'CREATE TABLE $_tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, note TEXT, date TEXT, startTime TEXT, endTime TEXT, remind INTEGER, repeat TEXT, color INTEGER, isCompleted INTEGER)');
        },
      );
      /////////////////
      print('Database Created');
    } catch (err) {
      print('Error in database' + err.toString());
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  static Future<int> insert_row_DB(Task _task) async {
    debugPrint('Insert function called');
    try {
      return await _db!.insert(
        _tableName,
        _task.toMap(),
      );
    } catch (e) {
      print('Error in insert function ' + e.toString());
      return 0;
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  static Future<int> delete_row_DB(int id) async {
    debugPrint('Delete function called');
    return await _db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  static Future<int> delete_all() async {
    debugPrint('Delete All function called');
    return await _db!.delete(_tableName);
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  static Future<int> update_row_DB(int id) async {
    debugPrint('Update function called');
    return await _db!.update(
      _tableName,
      {'isCompleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  static Future<List<Map<String, dynamic>>> query_DB() async {
    return await _db!.query(_tableName);
  }
}
