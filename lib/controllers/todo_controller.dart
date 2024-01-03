import 'package:flutter/material.dart';
import 'package:todoapp_sqlite/database/todo_list.dart';
import 'package:todoapp_sqlite/models/todo_model.dart';
import 'package:todoapp_sqlite/pages/todo_list_page.dart';

abstract class TodoListPageController extends State<TodoListPage> {
  final TodoList _todoList = TodoList();

  void addTodo(title, description) async {
    print("Adding a todo, received: '$title' and '$description'....");
    if (title.isNotEmpty && description.isNotEmpty) {
      print("creating todo object");
      final todo = Todo(title: title, description: description);
      print("saving todo object");
      await _todoList.insert(todo);
      print("saved todo, loading the page...");
    }
  }

  void updateTodo(todoId, title, description) async {
    if (todoId is int && title.isNotEmpty && description.isNotEmpty) {
      final updatedTodo = Todo(
        id: todoId,
        title: title,
        description: description,
      );
      await _todoList.update(updatedTodo);
    }
  }

  void deleteTodo(int id) async {
    await _todoList.delete(id);
  }
}