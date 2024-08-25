import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/data.dart';
import 'package:todolist/main.dart';

class EditTaskScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
final TaskEntity task;
  EditTaskScreen({super.key, required this.task});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.colorScheme.onSecondary,
        foregroundColor: themeData.colorScheme.primary,
        title: const Text('Edit Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          label: const Row(
            children: [
              Text('Save Changes'),
              SizedBox(
                width: 4,
              ),
              Icon(
                CupertinoIcons.check_mark,
                size: 16,
              )
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(flex: 1, child: PriorityCheckBox(
                  label: 'High',
                  color: primaryColor,
                  isSelected: task.priority==Priority.hight,
                )),
                const SizedBox(
                  width: 8,
                ),
                Flexible(flex: 1, child: PriorityCheckBox(
                  label: 'Normal',
                  color: const Color(0xffF09819),
                  isSelected: task.priority==Priority.normal,
                )),
                const SizedBox(
                  width: 8,
                ),
                Flexible(flex: 1, child: PriorityCheckBox(
                  label: 'Low',
                  color: const Color(0xff3BE1F1),
                  isSelected: task.priority==Priority.low,
                )),
              ],
            ),
            TextField(
              controller: _controller,
              decoration:
                  const InputDecoration(label: Text('Add a Task for today..')),
            ),
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;

  const PriorityCheckBox({super.key, required this.label, required this.color, required this.isSelected});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border:
            Border.all(width: 2, color: secondaryTextColor.withOpacity(0.2)),
      ),
      child: Stack(children: [
        Center(child: Text(label),),
        MyCheckBox(value: isSelected),
      ],),
    );
  }
}
