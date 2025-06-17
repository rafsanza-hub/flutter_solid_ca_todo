import 'package:solid_todo/features/todo/domain/entities/todo.dart';
import 'package:solid_todo/features/todo/domain/repositories/todo_repository.dart';

class GetTodosUseCase {
  final TodoRepository todoRepository;

  GetTodosUseCase(this.todoRepository);

  Future<List<Todo>> call() {
    return todoRepository.getTodos();
  }
}
