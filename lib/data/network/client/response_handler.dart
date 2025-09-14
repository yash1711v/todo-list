import 'package:dio/dio.dart';

class ResponseHandler {
  static dynamic handle(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw Exception("Bad request: ${response.data}");
      case 401:
        throw Exception("Unauthorized access");
      case 403:
        throw Exception("Forbidden request");
      case 404:
        throw Exception("Resource not found");
      case 500:
        throw Exception("Internal server error");
      default:
        throw Exception("Unexpected error: ${response.statusCode}");
    }
  }

  static Exception handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Exception("Connection timeout. Please check your internet connection.");
      case DioExceptionType.receiveTimeout:
        return Exception("Receive timeout. Please try again later.");
      case DioExceptionType.sendTimeout:
        return Exception("Send timeout. Please try again later.");
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'Unknown error';
        return Exception("Error $statusCode: $message");
      case DioExceptionType.connectionError:
        return Exception("Connection error. Please check your network.");
      case DioExceptionType.cancel:
        return Exception("Request was cancelled.");
      case DioExceptionType.unknown:
      default:
        return Exception("Something went wrong: ${error.message}");
    }
  }

}
