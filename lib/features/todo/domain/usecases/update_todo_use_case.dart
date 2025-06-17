import 'package:solid_todo/features/todo/domain/entities/todo.dart';
import 'package:solid_todo/features/todo/domain/repositories/todo_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository todoRepository;

  UpdateTodoUseCase({required this.todoRepository});

  Future<bool> call(Todo todo) async {
    return todoRepository.updateTodo(todo);
  }
}
