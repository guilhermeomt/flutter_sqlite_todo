import 'package:flutter_sqlite_todo/database/todo_database.dart';
import 'package:flutter_sqlite_todo/models/user.dart';

class UserRepository {
  UserRepository();

  Future<User> getUser(String username) async {
    final db = await TodoDatabase.instance.database;
    final maps = await db!.query(
      userTable,
      columns: UserFields.allFields,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('Username "$username" not found.');
    }
  }

  Future<List<User>> getAllUsers() async {
    final db = await TodoDatabase.instance.database;
    const orderBy = '${UserFields.username} ASC';
    final result = await db!.query(userTable, orderBy: orderBy);
    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<User> createUser(User user) async {
    final db = await TodoDatabase.instance.database;
    await db!.insert(
      userTable,
      user.toJson(),
    );
    return user;
  }

  Future<int> updateUser(User user) async {
    final db = await TodoDatabase.instance.database;
    return db!.update(
      userTable,
      user.toJson(),
      where: '${UserFields.username} = ?',
      whereArgs: [user.username],
    );
  }

  Future<int> deleteUser(String username) async {
    final db = await TodoDatabase.instance.database;
    return db!.delete(
      userTable,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );
  }
}
