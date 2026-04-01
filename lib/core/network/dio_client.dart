import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../config/env.dart';
import '../constants/app_constants.dart';

Dio createAnthropicDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.openAiBaseUrl,
      connectTimeout: AppConstants.networkTimeout,
      receiveTimeout: AppConstants.streamTimeout,
      headers: {
        'Authorization': 'Bearer ${Env.openAiApiKey}',
        'content-type': 'application/json',
      },
    ),
  );

  dio.interceptors.addAll([
    LogInterceptor(
      request: false,
      requestHeader: false,
      requestBody: false,
      responseBody: false,
      error: true,
    ),
  ]);

  return dio;
}
