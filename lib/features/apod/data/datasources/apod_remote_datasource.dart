import 'dart:async';
import 'package:attendrix_app/features/apod/data/dto/apod_dto.dart';
import 'package:attendrix_app/features/apod/domain/failures/apod_failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApodRemoteDatasource {
  ApodRemoteDatasource(this._dio, {required this.apiKey}) {
    _dio.options.baseUrl = 'https://api.nasa.gov/planetary/';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.sendTimeout = const Duration(seconds: 10);

    // 1. API Key Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['api_key'] = apiKey;
          return handler.next(options);
        },
      ),
    );

    // 2. Logging Interceptor
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
    }

    // 3. Retry Interceptor
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (err, handler) async {
          final count = err.requestOptions.extra['retry_count'] as int? ?? 0;
          final isRetryable = err.type == DioExceptionType.connectionTimeout ||
              err.type == DioExceptionType.sendTimeout ||
              err.type == DioExceptionType.receiveTimeout ||
              err.type == DioExceptionType.connectionError ||
              (err.response != null &&
                  err.response!.statusCode != null &&
                  err.response!.statusCode! >= 500);

          if (isRetryable && count < 3) {
            final nextCount = count + 1;
            // Exponential backoff: 2s, 4s, 8s
            final delay = Duration(seconds: 1 << nextCount);
            await Future<void>.delayed(delay);

            final options = err.requestOptions;
            options.extra['retry_count'] = nextCount;

            try {
              final response = await _dio.fetch<dynamic>(options);
              return handler.resolve(response);
            } on DioException catch (retryErr) {
              return handler.next(retryErr);
            }
          }
          return handler.next(err);
        },
      ),
    );
  }

  final Dio _dio;
  final String apiKey;

  Future<ApodDto> fetchApod({String? date}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (date != null) {
        queryParams['date'] = date;
      }
      final response = await _dio.get<Map<String, dynamic>>(
        'apod',
        queryParameters: queryParams,
      );

      if (response.data == null) {
        throw const ApodNotFound();
      }

      return ApodDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<ApodDto>> fetchApodRange({
    required String startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'start_date': startDate,
      };
      if (endDate != null) {
        queryParams['end_date'] = endDate;
      }
      final response = await _dio.get<List<dynamic>>(
        'apod',
        queryParameters: queryParams,
      );

      if (response.data == null) {
        return [];
      }

      return response.data!
          .map((dynamic item) => ApodDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  ApodFailure _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const ApodTimeout();
    }
    if (e.type == DioExceptionType.connectionError) {
      return const ApodNoConnection();
    }

    final response = e.response;
    if (response != null) {
      final status = response.statusCode;
      if (status == 403 || status == 429) {
        return const ApodRateLimited();
      }
      if (status == 404) {
        return const ApodNotFound();
      }
      if (status != null && status >= 500) {
        return const ApodServerError();
      }
    }

    return ApodUnknownFailure(e.message ?? 'An unexpected error occurred.');
  }
}
