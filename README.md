# Clean Architecture Todo - SOLID Principles Implementation

##  1. **Single Responsibility Principle (SRP)**
 *Setiap class hanya punya satu tanggung jawab dan satu alasan untuk berubah.*


`AddTodoUseCase`.

```dart
class AddTodoUseCase {
  final TodoRepository repository;
  
  AddTodoUseCase(this.repository);
  
  Future<void> call(Todo todo) {
    return repository.addTodo(todo);
  }
}
```

* Class ini **hanya bertanggung jawab menambahkan todo**.
* Tidak mengurus validasi UI, tidak menyimpan ke database, tidak kirim notifikasi.

### Contoh yang SALAH:
```dart
class TodoUseCase {
  List<Todo> todos = [];
  
  void addTodo(Todo todo) { todos.add(todo); }
  
  // seharusnya terpisah
  bool validateTodo(Todo todo) { return todo.title.isNotEmpty; }
  
  // seharusnya terpisah
  void addCategory(Category category) {  }
}
```

---

## 2. **Open/Closed Principle (OCP)**
 *Bisa di-extend, tidak perlu diubah.*

###  Kasus:
Base repository yang bisa di-extend untuk implementasi berbeda:

```dart
abstract class TodoRepository {
  Future<void> addTodo(Todo todo);
  Future<List<Todo>> getAllTodos();
  Future<Todo?> getTodoById(String id);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}
```

Implementasi yang sudah ada:

```dart
class LocalTodoRepository implements TodoRepository {
  List<Todo> _todos = [];
  
  @override
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
  }
  
  @override
  Future<List<Todo>> getAllTodos() async {
    return List.from(_todos);
  }
  
  @override
  Future<Todo?> getTodoById(String id) async {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
    }
  }
  
  @override
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
  }
}
```

Mau tambah implementasi baru? Extend tanpa ubah yang lama:

```dart
class DatabaseTodoRepository implements TodoRepository {
  @override
  Future<void> addTodo(Todo todo) async {
    // Simpan ke SQLite
    print("Saving to database: ${todo.title}");
  }
  
  @override
  Future<List<Todo>> getAllTodos() async {
    // Ambil dari SQLite
    return [];
  }
  
  @override
  Future<Todo?> getTodoById(String id) async {
    // Query dari database
    return null;
  }
  
  @override
  Future<void> updateTodo(Todo todo) async {
    // Update di database
  }
  
  @override
  Future<void> deleteTodo(String id) async {
    // Delete dari database
  }
}

class CachedTodoRepository implements TodoRepository {
  final TodoRepository _repository;
  final Map<String, Todo> _cache = {};
  
  CachedTodoRepository(this._repository);
  
  @override
  Future<void> addTodo(Todo todo) async {
    await _repository.addTodo(todo);
    _cache[todo.id] = todo;
  }
  
  @override
  Future<List<Todo>> getAllTodos() async {
    if (_cache.isEmpty) {
      final todos = await _repository.getAllTodos();
      for (final todo in todos) {
        _cache[todo.id] = todo;
      }
    }
    return _cache.values.toList();
  }
  
  @override
  Future<Todo?> getTodoById(String id) async {
    if (_cache.containsKey(id)) {
      return _cache[id];
    }
    final todo = await _repository.getTodoById(id);
    if (todo != null) {
      _cache[id] = todo;
    }
    return todo;
  }
  
  @override
  Future<void> updateTodo(Todo todo) async {
    await _repository.updateTodo(todo);
    _cache[todo.id] = todo;
  }
  
  @override
  Future<void> deleteTodo(String id) async {
    await _repository.deleteTodo(id);
    _cache.remove(id);
  }
}
```

###  Kenapa OCP?
* **menambah implementasi baru** tanpa mengubah code yang sudah ada.
* `LocalTodoRepository` tetap aman, bisa tambah `DatabaseTodoRepository` atau `CachedTodoRepository`.

---

## 3. **Liskov Substitution Principle (LSP)**
 *Subclass harus bisa menggantikan superclass tanpa membuat error.*

###  Kasus:
Semua implementasi `TodoRepository` harus bisa saling menggantikan:

```dart
// use case yang menerima TodoRepository apapun
class GetTodosUseCase {
  final TodoRepository todoRepository;

  GetTodosUseCase(this.todoRepository);

  Future<List<Todo>> call() {
    return todoRepository.getTodos();
  }
}

```

Semua implementasi ini bisa digunakan dengan aman:

```dart
class InMemoryTodoRepository implements TodoRepository {
  List<Todo> _todos = [];
  
  @override
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
  }
  
  @override
  Future<List<Todo>> getAllTodos() async {
    return List.from(_todos);
  }
  
  // ... implementasi lainnya
}

class ReadOnlyTodoRepository implements TodoRepository {
  final List<Todo> _fixedTodos = [
    Todo(id: "1", title: "Sample Todo", completed: false),
  ];
  
  @override
  Future<void> addTodo(Todo todo) async {
    // Read-only, tapi tetap tidak error - hanya tidak menyimpan
    print("Read-only repository: Cannot add todo");
  }
  
  @override
  Future<List<Todo>> getAllTodos() async {
    return List.from(_fixedTodos);
  }
  
  // ... implementasi lainnya
}
```

###  Kenapa LSP?
* `ReadOnlyTodoRepository` tetap valid sebagai `TodoRepository`, tidak melempar error.
* Semua implementasi bisa saling menggantikan dalam `TodoService`.

###  Contoh yang MELANGGAR LSP:
```dart
class BadTodoRepository implements TodoRepository {
  @override
  Future<void> addTodo(Todo todo) async {
    throw UnimplementedError("This repository cannot add todos!"); //  MELANGGAR LSP!
  }
  
  @override
  Future<List<Todo>> getAllTodos() async {
    return [];
  }
  
  // ... implementasi lainnya
}
```

---

##  4. **Interface Segregation Principle (ISP)**
 *Jangan paksa class mengimplementasikan method yang tidak dibutuhkan.*

###  Kasus:
 Don't do this:

```dart
abstract class TodoRepository {
  // Basic CRUD
  Future<void> addTodo(Todo todo);
  Future<List<Todo>> getAllTodos();
  Future<Todo?> getTodoById(String id);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
  
  // Advanced operations - ❌ tidak semua implementasi butuh ini
  Future<int> getTodoCount();
  Future<List<Todo>> getCompletedTodos();
  Future<List<Todo>> getPendingTodos();
}
```

###  Solusi:
Pecah interface berdasarkan kebutuhan:

```dart
// Interface dasar untuk CRUD
abstract class BasicTodoRepository {
  Future<void> addTodo(Todo todo);
  Future<List<Todo>> getAllTodos();
  Future<Todo?> getTodoById(String id);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
}


// Interface untuk statistik
abstract class TodoAnalytics {
  Future<int> getTodoCount();
  Future<int> getCompletedCount();
  Future<int> getPendingCount();
}
```

Implementasi sesuai kebutuhan:

```dart
// Simple repository hanya butuh CRUD basic
class SimpleTodoRepository implements TodoRepository {
  List<Todo> _todos = [];
  
  @override
  Future<void> addTodo(Todo todo) async => _todos.add(todo);
  
  @override
  Future<List<Todo>> getAllTodos() async => List.from(_todos);
  
  @override
  Future<Todo?> getTodoById(String id) async {
    try {
      return _todos.firstWhere((todo) => todo.id == id);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) _todos[index] = todo;
  }
  
  @override
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
  }
}
```

###  Kenapa ISP?
* `SimpleTodoRepository` tidak dipaksa implement statistik yang tidak dibutuhkan.
* bisa pilih interface mana yang mau diimplementasikan.

---

##  5. **Dependency Inversion Principle (DIP)**
 *Kode bergantung ke abstraksi, bukan implementasi langsung.*

###  Kasus:
Use case bergantung ke abstraksi:

```dart
class AddTodoUseCase {
  final TodoRepository repository; // ✅ Bergantung ke abstraksi
  
  AddTodoUseCase(this.repository);
  
  Future<void> call(String title) async {
    final todo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      completed: false,
    );
    
    await repository.addTodo(todo);
  }
}

class GetTodosUseCase {
  final TodoRepository repository; // ✅ Bergantung ke abstraksi
  
  GetTodosUseCase(this.repository);
  
  Future<List<Todo>> call() async {
    return await repository.getAllTodos();
  }
}

class UpdateTodoUseCase {
  final TodoRepository repository; // ✅ Bergantung ke abstraksi
  
  UpdateTodoUseCase(this.repository);
  
  Future<void> call(String id, String newTitle) async {
    final todo = await repository.getTodoById(id);
    if (todo != null) {
      final updatedTodo = todo.copyWith(title: newTitle);
      await repository.updateTodo(updatedTodo);
    }
  }
}
```

Provider yang menggunakan use case:

```dart
class TodoProvider extends ChangeNotifier {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodosUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  final TextEditingController titleC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<Todo> todos = [];
  bool isLoading = false;
  String? errorMessage;
  TodoProvider({
    required this.getTodosUseCase,
    required this.addTodosUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
  });

  Future<void> getTodos() async {
    errorMessage = null;
    try {
      final todos = await getTodosUseCase();
      this.todos = todos.map((e) => e as TodoModel).toList();
      print(todos.first.isCompleted);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> addTodo() async {
    try {
      final todo = Todo(
        id: DateTime.now().toString(),
        title: titleC.text,
        isCompleted: false,
        description: descriptionC.text,
      );
      print(titleC.text);
      await addTodosUseCase.call(todo);
      await getTodos();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      titleC.clear();
      descriptionC.clear();
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      print(titleC.text);
      await updateTodoUseCase(todo);
      await getTodos();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      titleC.clear();
      descriptionC.clear();
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      await deleteTodoUseCase(id);
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
```

Dependency injection:

```dart
// Bisa ganti implementasi dengan mudah
TodoRepository repository = SimpleTodoRepository();
// atau
// TodoRepository repository = AdvancedTodoRepository();

final addTodoUseCase = AddTodoUseCase(repository);
final getTodosUseCase = GetTodosUseCase(repository);
final updateTodoUseCase = UpdateTodoUseCase(repository);

final todoController = TodoController(
  addTodoUseCase: addTodoUseCase,
  getTodosUseCase: getTodosUseCase,
  updateTodoUseCase: updateTodoUseCase,
);
```

###  Kenapa DIP?
* Use case tidak tahu implementasi repository yang spesifik.
* Testing jadi mudah dengan mock repository.

###  Contoh yang MELANGGAR DIP:
```dart
class AddTodoUseCase {
  final SimpleTodoRepository repository = TodoRepository(); //  Hard dependency!
  
  Future<void> call(String title) async {
    // Terikat ke TodoRepository, susah testing & ganti implementasi
    final todo = Todo(id: "1", title: title, completed: false);
    await repository.addTodo(todo);
  }
}
```

---



##  Ringkasan
| Prinsip | Contoh  | Manfaat |
|---------|--------------------------|---------|
| **SRP** | Setiap use case punya satu tanggung jawab: `AddTodoUseCase`, `GetTodosUseCase` | Code mudah dipahami & di-maintain |
| **OCP** | Tambah implementasi repository baru tanpa ubah interface | Fitur baru tidak merusak yang lama |
| **LSP** | `SimpleTodoRepository` dan `AdvancedTodoRepository` bisa saling tukar | Polymorphism berjalan sempurna |
| **ISP** | Pisahkan `BasicTodoRepository`, `BatchTodoRepository`, `SearchableTodoRepository` | Tidak ada method yang dipaksakan |
| **DIP** | Use case bergantung ke interface repository, bukan implementasi konkret | Mudah testing & ganti implementasi |
