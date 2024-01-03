import 'package:flutter/material.dart';
import 'package:todoapp_sqlite/database/db_helper.dart';
import 'package:todoapp_sqlite/models/todo_model.dart';

class TodoList {
  /*
    Wrapper class on top of DBHelper class to
    acess to the helper class from the application
  */
  
  // Singletone DB constructor created in helper class
  final dbHero = DBHelper.dbHelper;

  Future<int> insert(Todo todo) async {
    return await dbHero.insertTodo(todo.toMap());
  }

  // Fetch rows from database and generate a list
  Future<List<Todo>> getAllTodos() async {
    final List<Map<String, dynamic>> maps = await dbHero.readTodos();
    return List.generate(maps.length, (idx) {
      return Todo(
        id: maps[idx]['id'],
        title: maps[idx]['title'],
        description: maps[idx]['description'],
      );
    });
  }

  // Update a todo
  Future<int> update(Todo todo) async {
    return await dbHero.updateTodo(todo.toMap());
  }

  // delete a todo
  Future<int> delete(int id) async {
    return await dbHero.deleteTodo(id);
  }

}