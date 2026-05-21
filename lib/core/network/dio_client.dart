import 'dart:async';

import 'package:dio/dio.dart';

import '../utils/app_logger.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          AppLogger.network('REQUEST → ${options.method} ${options.path}');

          AppLogger.info('Query Params → ${options.queryParameters}');

          handler.next(options);
        },

        onResponse: (response, handler) {
          AppLogger.success('RESPONSE → ${response.statusCode}');

          handler.next(response);
        },

        onError: (error, handler) {
          AppLogger.error('DIO ERROR → ${error.message}');

          handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _retryRequest(
      () => dio.get(path, queryParameters: queryParameters),
    );
  }

  Future<Response> _retryRequest(
    Future<Response> Function() requestFunction,
  ) async {
    int retryCount = 0;

    while (retryCount < 3) {
      try {
        retryCount++;

        AppLogger.retry('Attempt $retryCount...');

        return await requestFunction();
      } catch (e) {
        AppLogger.warning('Request failed on attempt $retryCount');

        if (retryCount >= 3) {
          rethrow;
        }

        final delay = Duration(seconds: retryCount * 2);

        AppLogger.retry('Retrying in ${delay.inSeconds} seconds...');

        await Future.delayed(delay);
      }
    }

    throw Exception('Max retries exceeded');
  }
}
