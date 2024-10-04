import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem(
      {super.key,
      required this.taskId,
      required this.taskTitle,
      required this.taskDescription,
      required this.isCompleted,
      this.onChange,
      this.deleteById,
      this.navigateEditTodoForm});

  final String taskId;
  final String taskTitle;
  final bool isCompleted;
  final String taskDescription;
  final Function(bool?)? onChange;
  final Function(String)? deleteById;
  final Function()? navigateEditTodoForm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 10, bottom: 0),
      child: Slidable(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(15)),
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
              Expanded(
                child: ListTile(
                    title: Text(
                      taskTitle,
                      style: TextStyle(
                        color: Colors.white,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Colors.white,
                        decorationThickness: 2,
                      ),
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                    ),
                    subtitle: Text(
                      taskDescription,
                      style: TextStyle(
                        color: Colors.white,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Colors.white,
                        decorationThickness: 2,
                      ),
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          navigateEditTodoForm!();
                        } else if (value == 'delete') {
                          deleteById!(taskId);
                        }
                      },
                      color: Colors.white,
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text("Edit"),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text("Delete"),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
