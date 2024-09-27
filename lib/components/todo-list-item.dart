import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem(
  {
    super.key, 
    required this.taskTitle, 
    required this.isCompleted, 
    this.onChange
  });

  final String taskTitle;
  final bool isCompleted;
  final Function(bool?)? onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 30, bottom: 0),
      child: Slidable(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.deepPurple, 
            borderRadius: BorderRadius.circular(15)
          ),
          child: Row(
            children: [
              Checkbox(
                value: isCompleted,
                onChanged: onChange,
                activeColor: Colors.white,
                checkColor: Colors.black,
                side: const BorderSide(color: Colors.white),
              ),
              const SizedBox(width: 10),
              Text(
                taskTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: 
                    isCompleted ? 
                    TextDecoration.lineThrough : 
                    TextDecoration.none,
                  decorationColor: Colors.white,
                  decorationThickness: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
