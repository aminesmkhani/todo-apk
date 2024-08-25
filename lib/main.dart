import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/data.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: primaryVariantColor),
  );
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryVariantColor = Color(0xff5C0AFF);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Color(0xff1D2830);
    final secondaryTextColor = Color(0xffAFBED0);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: secondaryTextColor),
            iconColor: secondaryTextColor,
            border: InputBorder.none),
        colorScheme: ColorScheme.light(
          primary: primaryColor,
          primaryContainer: primaryVariantColor,
          surface: primaryColor,
          onSurface: primaryTextColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(taskBoxName);
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditTaskScreen()));
          },
          label: Text('Add New Task')),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                themeData.colorScheme.primary,
                themeData.colorScheme.primaryContainer,
              ])),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'To DO List',
                          style: themeData.textTheme.titleLarge!
                              .apply(color: themeData.colorScheme.onPrimary),
                        ),
                        Icon(
                          CupertinoIcons.share,
                          color: themeData.colorScheme.onPrimary,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: themeData.colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20)
                          ]),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          label: Text('Search tasks'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder<Box<Task>>(
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: box.values.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Today',style:themeData.textTheme.headlineLarge!.apply(fontSizeFactor: 0.8),),
                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      width: 70,
                                      height: 3,
                                      decoration: BoxDecoration(color: primaryColor,borderRadius: BorderRadius.circular(1.5)),
                                    )
                                  ],
                                ),
                                MaterialButton(onPressed: (){},child: Text("Delete All"),)
                            ],
                          );
                        } else {
                          final Task task = box.values.toList()[index-1];
                          return Container(
                            child: Text(
                              task.name,
                              style: TextStyle(fontSize: 24),
                            ),
                          );
                        }
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTaskScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final task = Task();
            task.name = _controller.text;
            task.priority = Priority.low;
            if (task.isInBox) {
              task.save();
            } else {
              final Box<Task> box = Hive.box(taskBoxName);
              box.add(task);
            }

            Navigator.of(context).pop();
          },
          label: Text('Save Changes')),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(label: Text('Add a Task for today..')),
          ),
        ],
      ),
    );
  }
}
