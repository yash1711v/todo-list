import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../data/local/task_model_hive.dart';
import '../../../data/network/repo/repository.dart';
import '../model/task_model.dart';
import 'task_state.dart';

enum TaskActionType { add, delete }

class PendingTaskAction {
  final TaskActionType type;
  final TaskModel? task;
  final int? taskId;

  PendingTaskAction({required this.type, this.task, this.taskId});

  Map<String, dynamic> toJson() => {
    'type': type.toString(),
    'task': task?.toJson(),
    'taskId': taskId,
  };

  factory PendingTaskAction.fromJson(Map<String, dynamic> json) {
    return PendingTaskAction(
      type: TaskActionType.values
          .firstWhere((e) => e.toString() == json['type']),
      task: json['task'] != null ? TaskModel.fromJson(json['task']) : null,
      taskId: json['taskId'],
    );
  }
}

class TaskCubit extends Cubit<TaskState> {
  final AuthRepository authRepository;
  final Box<TaskHiveModel> taskBox;
  final Box pendingBox;

  TaskCubit(this.authRepository, this.taskBox, this.pendingBox)
      : super(TaskInitial()) {

    Connectivity().onConnectivityChanged.listen((status) {
      if (status != ConnectivityResult.none) {
        _syncPendingTasks();
      }
    });

    fetchTasks();
  }

  Future<void> fetchTasks() async {
    emit(TaskLoading());
    try {
      List<TaskModel> tasks = [];

      try {
        tasks = await authRepository.fetchTasks();
        _saveTasksToHive(tasks);
      } catch (_) {
        tasks = taskBox.values.map((e) => e.toTaskModel()).toList();
      }

      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> addTask(TaskModel task) async {
    emit(TaskLoading());
    taskBox.put(task.id, TaskHiveModel.fromTaskModel(task));

    try {
      await authRepository.addTask(task);
    } catch (_) {
      pendingBox.add(PendingTaskAction(type: TaskActionType.add, task: task).toJson());
    }

    await _mergeWithApiTasks();
  }

  Future<void> deleteTask(int id) async {
    taskBox.delete(id);

    try {
      await authRepository.deleteTask(id.toString());
    } catch (_) {
      pendingBox.add(PendingTaskAction(type: TaskActionType.delete, taskId: id).toJson());
    }

    await _mergeWithApiTasks();
  }

  void searchTasks(String query) {
    final filteredTasks = taskBox.values
        .map((e) => e.toTaskModel())
        .where((task) => task.todo.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(TaskLoaded(filteredTasks));
  }

  void _emitCurrentTasks() {
    final tasks = taskBox.values.map((e) => e.toTaskModel()).toList();
    emit(TaskLoaded(tasks));
  }

  Future<void> _syncPendingTasks() async {
    if (pendingBox.isEmpty) return;
    final pending = pendingBox.values.toList();

    for (var item in pending) {
      final action = PendingTaskAction.fromJson(Map<String, dynamic>.from(item));
      try {
        if (action.type == TaskActionType.add && action.task != null) {
          await authRepository.addTask(action.task!);
        } else if (action.type == TaskActionType.delete && action.taskId != null) {
          await authRepository.deleteTask(action.taskId.toString());
        }
        pendingBox.deleteAt(0);
      } catch (_) {

      }
    }

    await _mergeWithApiTasks();
  }

  Future<void> _mergeWithApiTasks() async {
    List<TaskModel> apiTasks = [];

    try {
      apiTasks = await authRepository.fetchTasks();
    } catch (_) {
      apiTasks = [];
    }


    final localOnlyTasks = taskBox.values
        .map((e) => e.toTaskModel())
        .where((task) => !apiTasks.any((api) => api.id == task.id))
        .toList();

    final mergedTasks = [...apiTasks, ...localOnlyTasks, ];

    _saveTasksToHive(mergedTasks);
    _emitCurrentTasks();
  }

  void _saveTasksToHive(List<TaskModel> tasks) {
    taskBox.clear();
    for (var task in tasks) {
      taskBox.put(task.id, TaskHiveModel.fromTaskModel(task));
    }
  }
}
