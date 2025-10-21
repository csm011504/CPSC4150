import 'package:flutter/material.dart';
import 'task_list_screen.dart';

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Data Storage To-Do',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const TaskListScreen(),
    );
  }
}
