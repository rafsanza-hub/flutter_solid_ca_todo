import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:solid_todo/features/todo/domain/entities/todo.dart';
import 'package:solid_todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:solid_todo/features/todo/domain/usecases/add_todo_use_case.dart';
import 'package:solid_todo/features/todo/domain/usecases/get_todos_use_case.dart';

import 'todo_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late MockTodoRepository mockTodoRepository;
  late AddTodoUseCase addTodoUseCase;
  late GetTodosUseCase getTodosUseCase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    addTodoUseCase = AddTodoUseCase(mockTodoRepository);
    getTodosUseCase = GetTodosUseCase(mockTodoRepository);
  });

  group('AddTodoUseCase', () {
    test('harus menambahkan todo', () async {
      // Arrange
      final todo = Todo(
          id: '1', description: 'test', title: 'Test Todo', isCompleted: false);
      when(mockTodoRepository.addTodo(todo)).thenAnswer((_) async => true);

      // Act
      final result = await addTodoUseCase.execute(todo);

      // Assert
      expect(result, true);
      verify(mockTodoRepository.addTodo(todo)).called(1);
    });
  });

  group('GetTodosUseCase', () {
    test('harus mengembalikan daftar todo', () async {
      // Arrange
      final todos = [
        Todo(
            id: '1',
            description: 'test',
            title: 'Test Todo 1',
            isCompleted: false),
        Todo(
            id: '2',
            description: 'test',
            title: 'Test Todo 2',
            isCompleted: true),
      ];
      when(mockTodoRepository.getTodos()).thenAnswer((_) async => todos);

      // Act
      final result = await getTodosUseCase.execute();

      // Assert
      expect(result, todos);
      verify(mockTodoRepository.getTodos()).called(1);
    });
  });
}
