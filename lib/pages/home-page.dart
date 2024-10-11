import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/todo-form.dart';
import 'package:myapp/components/todo-list-item.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/pages/sign-in-page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List todoList = [];
  String? displayName;
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    fetchTodos();
    _loadDisplayName();
  }

  Future<void> _loadDisplayName() async {
    final name = await getDisplayName();
    setState(() {
      displayName = name;
    });
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
      drawer: Drawer(
        backgroundColor: Colors.deepPurple.shade300,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    displayName ?? 'Guest',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                await supabase.auth.signOut();
                // Check if the widget is still mounted before using the context
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SignInPage()), // Replace LoginPage with your actual login page
                );
              },
            ),
          ],
        ),
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

  Future<String?> getDisplayName() async {
    final response = await Supabase.instance.client.auth.getUser();
    final user = response.user;
    if (user != null) {
      return user.userMetadata?['full_name'] as String?;
    }
    return "Guest";
  }
}
