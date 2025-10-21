// A task in the to-do list.
class Task {
  final int id;
  String title;
  bool completed;

  Task({required this.id, required this.title, this.completed = false});

  //Converts Task to Map
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed,
  };

  //Create a Task from Map
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      completed: json['completed'] ?? false,
    );
  }
}
