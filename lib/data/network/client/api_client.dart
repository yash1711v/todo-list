import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:todo/data/network/client/response_handler.dart';

abstract class NetworkMethods {
   final Dio dio;
   NetworkMethods(this.dio);
  Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters});

  Future<dynamic> post(String url, {Map<String, dynamic>? data});

  Future<dynamic> put(String url, {Map<String, dynamic>? data});

  Future<dynamic> delete(String url, {Map<String, dynamic>? data});
}



class ApiClient extends NetworkMethods {

  ApiClient(Dio _dio) : super(_dio);

  @override
  Future get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(url, queryParameters: queryParameters);
      return ResponseHandler.handle(response);
    } on DioException catch (e) {
      throw ResponseHandler.handleError(e);
    }
  }

  @override
  Future post(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(url, data: data);
      debugPrint("POST Response: ${response.data}");
      return ResponseHandler.handle(response);
    } on DioException catch (e) {
      throw ResponseHandler.handleError(e);
    }
  }

  @override
  Future put(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.put(url, data: data);
      return ResponseHandler.handle(response);
    } on DioException catch (e) {
      throw ResponseHandler.handleError(e);
    }
  }

  @override
  Future delete(String url, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.delete(url, data: data);
      return ResponseHandler.handle(response);
    } on DioException catch (e) {
      throw ResponseHandler.handleError(e);
    }
  }

}

