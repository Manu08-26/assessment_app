import '../model/task_model.dart';

class TaskController {
  final List<Task> tasks = [];

  void addTask(String title) {
    tasks.add(Task(id: DateTime.now().toIso8601String(), title: title));
  }

  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
  }
}
