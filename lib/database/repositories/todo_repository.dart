import 'package:flutter_sqlite_todo/database/todo_database.dart';
import 'package:flutter_sqlite_todo/models/todo.dart';

class TodoRepository {
  TodoRepository();

  Future<Todo> createTodo(Todo todo) async {
    final db = await TodoDatabase.instance.database;
    await db!.insert(todoTable, todo.toJson());
    return todo;
  }

  Future<int> toggleTodoDone(Todo todo) async {
    final db = await TodoDatabase.instance.database;
    todo.done = !todo.done;
    return db!.update(
      todoTable,
      todo.toJson(),
      where: '${TodoFields.title} = ? AND ${TodoFields.username} = ?',
      whereArgs: [todo.title, todo.username],
    );
  }

  Future<List<Todo>> getAllTodos(String username) async {
    final db = await TodoDatabase.instance.database;
    const orderBy = '${TodoFields.created} DESC';
    final result = await db!.query(todoTable,
        orderBy: orderBy,
        where: '${TodoFields.username} = ?',
        whereArgs: [username]);
    return result.map((json) => Todo.fromJson(json)).toList();
  }

  Future<int> deleteTodo(Todo todo) async {
    final db = await TodoDatabase.instance.database;
    return db!.delete(
      todoTable,
      where: '${TodoFields.title} = ? AND ${TodoFields.username} = ?',
      whereArgs: [todo.title, todo.username],
    );
  }
}
