import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_sqlite_todo/models/todo.dart';
import 'package:flutter_sqlite_todo/models/user.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._internal();
  static Database? _database;
  TodoDatabase._internal();

  Future _onCreate(Database db, int version) async {
    const userUsernameType = "TEXT PRIMARY KEY NOT NULL";
    const textType = "TEXT NOT NULL";
    const boolType = "BOOLEAN NOT NULL";

    await db.execute('''
      CREATE TABLE $userTable (
        ${UserFields.username} $userUsernameType,
        ${UserFields.name} $textType,
      );
    ''');

    await db.execute('''
    CREATE TABLE $todoTable (
      ${TodoFields.username} $userUsernameType,
      ${TodoFields.title} $textType,
      ${TodoFields.done} $boolType,
      ${TodoFields.created} $textType,
      FOREIGN KEY ${TodoFields.username} REFERENCES $userTable (${UserFields.username})
    );
    ''');
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todo.db');
    return _database!;
  }
}
