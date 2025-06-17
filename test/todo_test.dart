import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:solid_todo/features/todo/domain/entities/todo.dart';
import 'package:solid_todo/features/todo/domain/repositories/todo_repository.dart';
import 'package:solid_todo/features/todo/domain/usecases/add_todo_use_case.dart';
import 'package:solid_todo/features/todo/domain/usecases/delete_todo_use_case.dart';
import 'package:solid_todo/features/todo/domain/usecases/get_todos_use_case.dart';
import 'package:solid_todo/features/todo/domain/usecases/update_todo_use_case.dart';

import 'todo_test.mocks.dart';

@GenerateMocks([TodoRepository])
void main() {
  late MockTodoRepository mockTodoRepository;
  late AddTodoUseCase addTodoUseCase;
  late GetTodosUseCase getTodosUseCase;
  late UpdateTodoUseCase updateTodoUseCase;
  late DeleteTodoUseCase deleteTodoUseCase;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    addTodoUseCase = AddTodoUseCase(mockTodoRepository);
    getTodosUseCase = GetTodosUseCase(mockTodoRepository);
    updateTodoUseCase = UpdateTodoUseCase(todoRepository: mockTodoRepository);
    deleteTodoUseCase = DeleteTodoUseCase(todoRepository: mockTodoRepository);
  });

  group('AddTodoUseCase', () {
    test('harus menambahkan todo', () async {
      // Arrange
      final todo = Todo(
          id: '1', description: 'test', title: 'Test Todo', isCompleted: false);
      when(mockTodoRepository.addTodo(todo)).thenAnswer((_) async => true);

      // Act
      final result = await addTodoUseCase(todo);

      // Assert
      expect(result, true);
      verify(mockTodoRepository.addTodo(todo)).called(1);
    });
  });

  group('UpdateTodoUseCase', () {
    test('harus mengupdate todo', () async {
      // Arrange
      final todo = Todo(
          id: '1', description: 'test', title: 'Test Todo', isCompleted: false);
      when(mockTodoRepository.updateTodo(todo)).thenAnswer((_) async => true);

      // Act
      final result = await updateTodoUseCase(todo);

      // Assert
      expect(result, true);
      verify(mockTodoRepository.updateTodo(todo)).called(1);
    });
  });

  group('DeleteTodoUseCase', () {
    test('harus menghapus todo', () async {
      // Arrange
      const todoId = '1';
      when(mockTodoRepository.deleteTodo(todoId)).thenAnswer((_) async => true);

      // Act
      await deleteTodoUseCase(todoId);

      // Assert
      verify(mockTodoRepository.deleteTodo(todoId)).called(1);
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
      final result = await getTodosUseCase.call();

      // Assert
      expect(result, todos);
      verify(mockTodoRepository.getTodos()).called(1);
    });
  });
}
