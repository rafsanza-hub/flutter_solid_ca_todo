import 'package:solid_todo/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:solid_todo/features/todo/data/models/todo_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos (
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );
  }

  @override
  Future<bool> insertTodo(TodoModel todo) async {
    final db = await database;
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  @override
  Future<List<TodoModel>> getAllTodos() async {
    final db = await database;
    final maps = await db.query('todos');

    return List.generate(maps.length, (i) {
      return TodoModel.fromMap(maps[i]);
    });
  }

  @override
  Future<bool> deleteTodo(String id) async {
    final db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]) > 0;
  }

  @override
  Future<bool> updateTodo(TodoModel todo) async {
    final db = await database;
    return await db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]) > 0;
  }

  @override
  Future<bool> completeTodo(TodoModel todo) async {
    final db = await database;
    todo.isCompleted = !todo.isCompleted;
    return await db.update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]) > 0;
  }
}
