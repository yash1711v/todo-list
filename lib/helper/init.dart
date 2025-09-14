
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../constants/api_constants.dart';
import '../data/network/client/api_client.dart';
import '../data/network/repo/repository.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<Dio>(() =>  Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {"Content-Type": "application/json"},
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  ));

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));

  getIt.registerLazySingleton<AuthRepository>(
          () => AuthRepositoryImpl(getIt<ApiClient>()));
}
