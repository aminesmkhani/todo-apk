import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/data.dart';
import 'package:todolist/main.dart';

class EditTaskScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  EditTaskScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final task = TaskEntity();
            task.name = _controller.text;
            task.priority = Priority.low;
            if (task.isInBox) {
              task.save();
            } else {
              final Box<TaskEntity> box = Hive.box(taskBoxName);
              box.add(task);
            }

            Navigator.of(context).pop();
          },
          label: const Text('Save Changes')),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(label: Text('Add a Task for today..')),
          ),
        ],
      ),
    );
  }
}
