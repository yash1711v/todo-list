import 'package:flutter/cupertino.dart';

import '../../../constants/api_constants.dart';
import '../../../views/TaskListScreen/model/task_model.dart';
import '../client/api_client.dart';



abstract class AuthRepository {
  final ApiClient apiClient;

  AuthRepository(this.apiClient);
  Future<dynamic> fetchTasks();
  Future<dynamic> addTask(TaskModel data);
  Future<dynamic> deleteTask(String id);
}


class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl(ApiClient apiClient) : super(apiClient);

  @override
  Future<List<TaskModel>> fetchTasks() async {
    final response = await apiClient.get(ApiConstants.fetchTasks);
    // debugPrint("Response: ${response}");
    final data = response['todos'] as List<dynamic>;
    return data.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<void> addTask(TaskModel task) async {
    try {
      debugPrint("Adding task: ${task.toJson()}");
      await apiClient.post(ApiConstants.addTask, data: task.toJson());
      debugPrint("Task added successfully");
    } catch (e, stackTrace) {
      debugPrint("Error adding task: $e");
      debugPrint("$stackTrace");
      throw e;
    }
  }



  Future<void> deleteTask(String id) async {
    await apiClient.delete(ApiConstants.deleteTask(id));
  }
}
