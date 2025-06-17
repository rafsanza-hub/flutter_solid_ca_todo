import 'package:solid_todo/features/todo/data/models/todo_model.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });
}

final tes = TodoModel(
  id: 's',
  title: 's',
  description: 'description',
  isCompleted: true,
);

final Todo todo = tes;
