import 'package:flutter/material.dart';
import 'package:to_do_list/models/to_do_model.dart';
import 'package:to_do_list/screens/add_todo_screen.dart';
import 'package:to_do_list/services/database_services.dart';
import 'package:to_do_list/widgets/todo_tile.dart';
import 'package:to_do_list/widgets/todos_overview.dart';

class TodoListScreen extends StatefulWidget {
  TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  Future<void> _getTodos() async {
    final todos = await DatabaseService.instance.getAllTodos();
    if (mounted) {
      setState(() => _todos = todos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) return TodosOverview(todos: _todos);
            final todo = _todos[index - 1];
            return TodoTile(
              todo: todo,
              updateTodos: _getTodos,
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: _todos.length + 1,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => AddTodoScreen(
              updateTodos: _getTodos,
            ),
          ),
        ),
      ),
    );
  }
}
