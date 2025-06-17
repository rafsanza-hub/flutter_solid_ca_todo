import 'package:solid_todo/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:solid_todo/features/todo/data/models/todo_model.dart';
import 'package:solid_todo/features/todo/domain/entities/todo.dart';
import 'package:solid_todo/features/todo/domain/repositories/todo_repository.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});
  @override
  Future<bool> addTodo(Todo todo) {
    TodoModel todoModel = TodoModel.fromEntity(todo);
    return localDataSource.insertTodo(todoModel);
  }

  @override
  Future<List<Todo>> getTodos() {
    return localDataSource.getAllTodos();
  }

  @override
  Future<bool> updateTodo(Todo todo) {
    TodoModel todoModel = TodoModel.fromEntity(todo);
    return localDataSource.updateTodo(todoModel);
  }

  @override
  Future<bool> deleteTodo(String id) {
    return localDataSource.deleteTodo(id);
  }

  @override
  Future<bool> completeTodo(Todo todo) {
    TodoModel todoModel = TodoModel.fromEntity(todo);
    return localDataSource.completeTodo(todoModel);
  }
}
