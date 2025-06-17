import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solid_todo/features/todo/domain/entities/todo.dart';
import 'package:solid_todo/features/todo/presentation/providers/todo_provider.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo List'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder(
          future: Provider.of<TodoProvider>(context, listen: false).getTodos(),
          builder: (context, snapshot) {
            return Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                if (todoProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (todoProvider.errorMessage != null) {
                  return Center(
                      child: Text('Error: ${todoProvider.errorMessage}'));
                } else if (todoProvider.todos.isEmpty) {
                  return const Center(child: Text('No todos found.'));
                } else {
                  return ListView.separated(
                    itemCount: todoProvider.todos.length,
                    itemBuilder: (context, index) {
                      final Todo todo = todoProvider.todos[index];
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              todoProvider.titleC.text = todo.title;
                              todoProvider.descriptionC.text = todo.description;
                              return AlertDialog(
                                title: const Text('Edit Todo'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      todoProvider.descriptionC.clear();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      todoProvider.updateTodo(Todo(
                                        isCompleted: todo.isCompleted,
                                        id: todo.id,
                                        title: todoProvider.titleC.text,
                                        description:
                                            todoProvider.descriptionC.text,
                                      ));
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Update'),
                                  ),
                                ],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                content: Form(
                                  key: todoProvider.formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: todoProvider.titleC,
                                      ),
                                      TextFormField(
                                        controller: context
                                            .read<TodoProvider>()
                                            .descriptionC,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).then((context) {
                            todoProvider.descriptionC.clear();
                            todoProvider.titleC.clear();
                          });
                        },
                        child: Dismissible(
                          key: Key(todo.id.toString()),
                          background: Container(
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.centerRight,
                            child: const Icon(Icons.delete_outline,
                                color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            todoProvider.deleteTodo(todo.id);
                          },
                          direction: DismissDirection.endToStart,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(todo.title),
                              subtitle: Text(' ${todo.description}'),
                              trailing: GestureDetector(
                                onTap: () {
                                  todoProvider.updateTodo(Todo(
                                    id: todo.id,
                                    title: todo.title,
                                    description: todo.description,
                                    isCompleted: !todo.isCompleted,
                                  ));
                                },
                                child: Icon(
                                  todo.isCompleted
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: todo.isCompleted
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                  );
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          final todoProvider = context.read<TodoProvider>();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Tambah Tugas'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(elevation: WidgetStateProperty.all(0)),
                    onPressed: () {
                      if (todoProvider.formKey.currentState!.validate()) {
                        todoProvider.addTodo();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Update'),
                  ),
                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: Form(
                  key: todoProvider.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Judul',
                          labelText: 'Judul',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: todoProvider.titleC,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Deskripsi',
                          labelText: 'Deskripsi',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: todoProvider.descriptionC,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ).then((_) {
            // ini akan dipanggil setelah dialog ditutup
            todoProvider.titleC.clear();
            todoProvider.descriptionC.clear();
          });
        },
      ),
    );
  }
}
