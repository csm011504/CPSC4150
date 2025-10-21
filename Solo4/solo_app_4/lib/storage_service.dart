import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_model.dart';

class StorageService {
  static const _key = 'tasks';

  //Load tasks
  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return []; //First run or empty

    try {
      final List decoded = json.decode(jsonString);
      return decoded.map((item) => Task.fromJson(item)).toList();
    } catch (e) {
      //Handle corrupted data
      return [];
    }
  }

  //Save tasks list
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  //Clear all tasks
  static Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
