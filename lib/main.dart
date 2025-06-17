import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_todo/features/todo/data/datasources/todo_local_data_source_impl.dart';
import 'package:solid_todo/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:solid_todo/features/todo/domain/usecases/add_todo_use_case.dart';
import 'package:solid_todo/features/todo/domain/usecases/delete_todo_use_case.dart';
import 'package:solid_todo/features/todo/domain/usecases/get_todos_use_case.dart';
import 'package:solid_todo/features/todo/domain/usecases/update_todo_use_case.dart';
import 'package:solid_todo/features/todo/presentation/providers/todo_provider.dart';
import 'package:solid_todo/features/todo/presentation/screens/todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(
        deleteTodoUseCase: DeleteTodoUseCase(
          todoRepository: TodoRepositoryImpl(
            localDataSource: TodoLocalDataSourceImpl(),
          ),
        ),
        updateTodoUseCase: UpdateTodoUseCase(
          todoRepository: TodoRepositoryImpl(
            localDataSource: TodoLocalDataSourceImpl(),
          ),
        ),
        addTodosUseCase: AddTodoUseCase(
          TodoRepositoryImpl(
            localDataSource: TodoLocalDataSourceImpl(),
          ),
        ),
        getTodosUseCase: GetTodosUseCase(
          TodoRepositoryImpl(
            localDataSource: TodoLocalDataSourceImpl(),
          ),
        ),
      ),
      child: const MaterialApp(home: TodoScreen()),
    );
  }
}
