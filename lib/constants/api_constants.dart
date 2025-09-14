class ApiConstants {
  static const String baseUrl = "https://dummyjson.com/";
  static const String fetchTasks = "${baseUrl}todos";
  static const String addTask = "${baseUrl}todos/add";
  static String deleteTask(String id) => "${baseUrl}todos/$id";

}

