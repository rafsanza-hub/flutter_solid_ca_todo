import 'dart:convert';
import 'package:solid_todo/features/todo/domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required super.id,
    required super.title,
    required super.description,
    required super.isCompleted,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) => TodoModel(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        isCompleted: map['isCompleted'] == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted ? 1 : 0,
      };

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) =>
      TodoModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  factory TodoModel.fromEntity(Todo todo) => TodoModel(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isCompleted: todo.isCompleted,
      );
}
