import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/components/todo-form.dart';
import 'package:myapp/components/todo-list-item.dart';
import 'package:http/http.dart' as http;

class HomagePage extends StatefulWidget {
  const HomagePage({super.key});

  @override
  State<HomagePage> createState() => _HomagePageState();
}

class _HomagePageState extends State<HomagePage> {
  List todoList = [];

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  void onCheckboxChanged(index) {
    final updatedStatus = !todoList[index]["is_completed"];

    setState(() {
      todoList[index]["is_completed"] = updatedStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      appBar: AppBar(
        title: const Text('Todo App'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: fetchTodos,
        child: ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (BuildContext context, index) {
              final item = todoList[index] as Map;
              return TodoListItem(
                taskId: item["_id"],
                taskTitle: item["title"],
                taskDescription: item["description"],
                isCompleted: item["is_completed"],
                onChange: (value) => onCheckboxChanged(index),
                deleteById: (value) => deleteById(item["_id"]),
                navigateEditTodoForm: () => navigateEditTodoForm(index),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateAddTodoForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  void navigateAddTodoForm() {
    final route = MaterialPageRoute(builder: (context) => const TodoForm());
    Navigator.push(context, route);
  }

  void navigateEditTodoForm(index) {
    Map item = todoList[index];
    final route = MaterialPageRoute(
        builder: (context) => TodoForm(
              todo: item,
            ));
    Navigator.push(context, route);
  }

  ///
  /// final respone = ["key1": "value1"
  /// "key1": "value1"]
  ///

  Future<void> fetchTodos() async {
    final response = await http
        .get(Uri.parse("https://api.nstack.in/v1/todos?page=1&limit=10"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map;
      final result = data["items"] as List;
      setState(() {
        todoList = result;
      });
    }
  }

  Future<void> deleteById(String taskId) async {
    final url = Uri.parse("https://api.nstack.in/v1/todos/$taskId");
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      final filtered =
          todoList.where((element) => element["_id"] != taskId).toList();
      setState(() {
        todoList = filtered;
      });
    }
  }
}
