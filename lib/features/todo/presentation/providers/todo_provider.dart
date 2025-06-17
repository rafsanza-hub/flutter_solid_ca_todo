import 'package:flutter/material.dart';
import 'package:solid_todo/features/todo/data/models/todo_model.dart';
import 'package:solid_todo/features/todo/domain/entities/todo.dart';

import 'package:solid_todo/features/todo/domain/usecases/add_todo_use_case.dart';
import 'package:solid_todo/features/todo/domain/usecases/delete_todo_use_case.dart';
import 'package:solid_todo/features/todo/domain/usecases/get_todos_use_case.dart';
import 'package:solid_todo/features/todo/domain/usecases/update_todo_use_case.dart';

class TodoProvider extends ChangeNotifier {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodosUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  final TextEditingController titleC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<Todo> todos = [];
  bool isLoading = false;
  String? errorMessage;
  TodoProvider({
    required this.getTodosUseCase,
    required this.addTodosUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
  });

  Future<void> getTodos() async {
    errorMessage = null;
    try {
      final todos = await getTodosUseCase();
      this.todos = todos.map((e) => e as TodoModel).toList();
      print(todos.first.isCompleted);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> addTodo() async {
    try {
      final todo = Todo(
        id: DateTime.now().toString(),
        title: titleC.text,
        isCompleted: false,
        description: descriptionC.text,
      );
      print(titleC.text);
      await addTodosUseCase.call(todo);
      await getTodos();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      titleC.clear();
      descriptionC.clear();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      print(titleC.text);
      await updateTodoUseCase(todo);
      await getTodos();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      titleC.clear();
      descriptionC.clear();
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await deleteTodoUseCase(id);
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
