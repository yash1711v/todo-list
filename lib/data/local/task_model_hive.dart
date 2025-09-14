import 'package:hive/hive.dart';

import '../../views/TaskListScreen/model/task_model.dart';
part 'task_model_hive.g.dart';

@HiveType(typeId: 0)
class TaskHiveModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String todo;

  @HiveField(2)
  bool completed;

  @HiveField(3)
  int userId;

  TaskHiveModel({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory TaskHiveModel.fromTaskModel(TaskModel task) {
    return TaskHiveModel(
      id: task.id,
      todo: task.todo,
      completed: task.completed,
      userId: task.userId,
    );
  }

  TaskModel toTaskModel() {
    return TaskModel(
      id: id,
      todo: todo,
      completed: completed,
      userId: userId,
    );
  }
}
