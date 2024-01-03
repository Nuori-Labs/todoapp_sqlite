// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:todoapp_sqlite/controllers/todo_controller.dart';
import 'package:todoapp_sqlite/database/todo_list.dart';
import 'package:todoapp_sqlite/models/todo_model.dart';

class TodoListPage extends StatefulWidget {

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends TodoListPageController {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _updateTitleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _updateDescriptionController = TextEditingController();
  final TodoList _todoRepository = TodoList();

  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final todos = await _todoRepository.getAllTodos();
    setState(() {
      _todos = todos;
    });
  }

  // void _addTodo() async {
  //   final title = _titleController.text;
  //   final description = _descriptionController.text;
  //   addTodo(title, description); 
    // _titleController.clear();
    // _descriptionController.clear();
  // }

  // void _updateTodo(Todo todo) async {
  //   final todoId = todo.id;
  //   final title = _titleController.text;
  //   final description = _descriptionController.text;
  //   updateTodo(todoId, title, description);
  //   _titleController.clear();
  //   _descriptionController.clear();
  // }

  // void _deleteTodo(int id) async {
  //   deleteTodo(id);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Todo title'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                ElevatedButton(
                  onPressed: () {
                    addTodo(_titleController.text, _descriptionController.text);
                    _titleController.clear();
                    _descriptionController.clear();
                    _loadTodos();
                  },
                  child: Text('Add Todo'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(todo.title!),
                  subtitle: Text(todo.description!),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _updateTitleController.text = todo.title!;
                      _updateDescriptionController.text = todo.description!;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Edit Todo'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _updateTitleController,
                                decoration:
                                    InputDecoration(labelText: 'Todo title'),
                              ),
                              TextField(
                                controller: _updateDescriptionController,
                                decoration:
                                    InputDecoration(labelText: 'Description'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                updateTodo(todo.id!, _updateTitleController.text, _updateDescriptionController.text);
                                Navigator.of(context).pop();
                                _loadTodos();
                              },
                              child: Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Delete Todo'),
                        content: Text(
                            'Are you sure you want to delete this todo?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteTodo(todo.id!);
                              Navigator.of(context).pop();
                              _loadTodos();
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}