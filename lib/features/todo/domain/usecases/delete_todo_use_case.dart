import 'package:solid_todo/features/todo/domain/repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository todoRepository;

  DeleteTodoUseCase({required this.todoRepository});
  Future<void> call(String todoId) async {
    await todoRepository.deleteTodo(todoId);
  }
}
