import 'package:solid_todo/features/todo/domain/entities/todo.dart';
import 'package:solid_todo/features/todo/domain/repositories/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository todoRepository;

  AddTodoUseCase(this.todoRepository);

  Future<bool> call(Todo todo) {
    return todoRepository.addTodo(todo);
  }
}
