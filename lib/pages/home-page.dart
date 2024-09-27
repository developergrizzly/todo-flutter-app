import 'package:flutter/material.dart';
import 'package:myapp/components/todo-list-item.dart';

class HomagePage extends StatefulWidget {
  const HomagePage({super.key});

  @override
  State<HomagePage> createState() => _HomagePageState();
}

class _HomagePageState extends State<HomagePage> {
  final _newTaskTextFieldController = TextEditingController();

  List todoList = [
    ["Taks 1", false],
    ["Task 2", false]
  ];

  void onCheckboxChanged(index) {
    setState(() {
      todoList[index][1] = !todoList[index][1];
    });
  }

  void saveNewTask() {
    setState(() {
      todoList.add([_newTaskTextFieldController.text, false]);
      _newTaskTextFieldController.clear();
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
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (BuildContext context, index) {
            return TodoListItem(
              taskTitle: todoList[index][0],
              isCompleted: todoList[index][1],
              onChange: (value) => onCheckboxChanged(index),
            );
          }),
      floatingActionButton: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _newTaskTextFieldController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.deepPurple.shade200,
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  hintText: 'Add a new task',
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: saveNewTask,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
