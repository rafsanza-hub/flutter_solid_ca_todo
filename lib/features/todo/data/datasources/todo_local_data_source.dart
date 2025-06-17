import 'package:solid_todo/features/todo/data/models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<bool> insertTodo(TodoModel todo);
  Future<List<TodoModel>> getAllTodos();
  Future<bool> deleteTodo(String id);
  Future<bool> updateTodo(TodoModel todo);
  Future<bool> completeTodo(TodoModel todo); 
}
