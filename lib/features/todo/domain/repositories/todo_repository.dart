import 'package:solid_todo/features/todo/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<bool> addTodo(Todo todo);
  Future<List<Todo>> getTodos();
}
