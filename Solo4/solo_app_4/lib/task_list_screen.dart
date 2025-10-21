import 'package:flutter/material.dart';
import 'task_model.dart';
import 'storage_service.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await StorageService.loadTasks();
    setState(() => _tasks = tasks);
  }

  Future<void> _saveTasks() async {
    await StorageService.saveTasks(_tasks);
  }

  void _addTask() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Save')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _tasks.add(Task(id: DateTime.now().millisecondsSinceEpoch, title: result));
      });
      await _saveTasks();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task added')));
    }
  }

  void _editTask(Task task) async {
    final controller = TextEditingController(text: task.title);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: const Text('Save')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        task.title = result;
      });
      await _saveTasks();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task updated')));
    }
  }

  void _deleteTask(Task task) async {
    setState(() {
      _tasks.remove(task);
    });
    await _saveTasks();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task deleted')));
  }

  void _toggleComplete(Task task) async {
    setState(() {
      task.completed = !task.completed;
    });
    await _saveTasks();
  }

  void _clearAll() async {
    await StorageService.clearTasks();
    setState(() => _tasks = []);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All tasks cleared')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(onPressed: _clearAll, icon: const Icon(Icons.delete_forever)),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet.'))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (_, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.completed ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: Checkbox(
              value: task.completed,
              onChanged: (_) => _toggleComplete(task),
            ),
            onTap: () => _editTask(task),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteTask(task),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
