import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/main.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller = TextEditingController(text: widget.task.name);

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
            widget.task.name = _controller.text;
            widget.task.priority = widget.task.priority;
            if (widget.task.isInBox) {
              widget.task.save();
            } else {
              final Box<TaskEntity> box = Hive.box(taskBoxName);
              box.add(widget.task);
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
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.hight;
                        });
                      },
                      label: 'High',
                      color: primaryColor,
                      isSelected: widget.task.priority == Priority.hight,
                    )),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.normal;
                        });
                      },
                      label: 'Normal',
                      color: normalColor,
                      isSelected: widget.task.priority == Priority.normal,
                    )),
                const SizedBox(
                  width: 8,
                ),
                Flexible(
                    flex: 1,
                    child: PriorityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.low;
                        });
                      },
                      label: 'Low',
                      color: lowColor,
                      isSelected: widget.task.priority == Priority.low,
                    )),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                  label: Text(
                'Add a Task for today..',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .apply(fontSizeFactor: 1.2),
              )),
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
  final GestureTapCallback onTap;

  const PriorityCheckBox(
      {super.key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border:
              Border.all(width: 2, color: secondaryTextColor.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
                right: 8,
                bottom: 0,
                top: 0,
                child: Center(
                    child: PriorityCheckBoxShape(
                  value: isSelected,
                  color: color,
                ))),
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;
  const PriorityCheckBoxShape(
      {super.key, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
      child: value
          ? Icon(CupertinoIcons.check_mark,
              size: 12, color: themeData.colorScheme.onPrimary)
          : null,
    );
  }
}
