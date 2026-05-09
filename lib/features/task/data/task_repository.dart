import '../model/task_model.dart';

class TaskRepository {
  final List<Task> _tasks = [];

  List<Task> list() {
    return List.unmodifiable(_tasks);
  }

  void add(String title) {
    _tasks.add(Task(id: DateTime.now().toIso8601String(), title: title));
  }

  void delete(String id) {
    _tasks.removeWhere((t) => t.id == id);
  }
}
