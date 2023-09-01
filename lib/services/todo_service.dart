import 'package:flutter/material.dart';
import 'package:flutter_sqlite_todo/database/repositories/todo_repository.dart';
import 'package:flutter_sqlite_todo/models/todo.dart';

class TodoService with ChangeNotifier {
  final _todoRepository = TodoRepository();
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  Future<String> getTodos(String username) async {
    try {
      _todos = await _todoRepository.getAllTodos(username);
      notifyListeners();
    } catch (e) {
      return e.toString();
    }
    return "OK";
  }

  Future<String> deleteTodo(Todo todo) async {
    try {
      await _todoRepository.deleteTodo(todo);
    } catch (e) {
      return e.toString();
    }
    String result = await getTodos(todo.username);
    return result;
  }

  Future<String> createTodo(Todo todo) async {
    try {
      await _todoRepository.createTodo(todo);
    } catch (e) {
      return e.toString();
    }
    String result = await getTodos(todo.username);
    return result;
  }

  Future<String> toggleTodoDone(Todo todo) async {
    try {
      await _todoRepository.toggleTodoDone(todo);
    } catch (e) {
      return e.toString();
    }
    String result = await getTodos(todo.username);
    return result;
  }
}
