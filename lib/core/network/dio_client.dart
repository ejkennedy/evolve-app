import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../config/env.dart';
import '../constants/app_constants.dart';

Dio createAnthropicDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.anthropicBaseUrl,
      connectTimeout: AppConstants.networkTimeout,
      receiveTimeout: AppConstants.streamTimeout,
      headers: {
        'x-api-key': Env.anthropicApiKey,
        'anthropic-version': '2023-06-01',
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
