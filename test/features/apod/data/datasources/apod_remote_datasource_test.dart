import 'package:attendrix_app/features/apod/data/datasources/apod_remote_datasource.dart';
import 'package:attendrix_app/features/apod/domain/failures/apod_failure.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../fixtures/apod_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late BaseOptions baseOptions;
  late Interceptors interceptors;
  late ApodRemoteDatasource datasource;

  setUp(() {
    mockDio = MockDio();
    baseOptions = BaseOptions();
    interceptors = Interceptors();

    when(() => mockDio.options).thenReturn(baseOptions);
    when(() => mockDio.interceptors).thenReturn(interceptors);

    datasource = ApodRemoteDatasource(mockDio, apiKey: 'DEMO_KEY');
  });

  group('ApodRemoteDatasource Tests', () {
    test('fetchApod success should return ApodDto', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          'apod',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: ApodFixtures.imageResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: 'apod'),
        ),
      );

      final result = await datasource.fetchApod();

      expect(result.date, '2024-10-24');
      expect(result.mediaType, 'image');
    });

    test('fetchApod date parameter should be passed in queryParameters', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          'apod',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: ApodFixtures.imageResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: 'apod'),
        ),
      );

      await datasource.fetchApod(date: '2024-10-24');

      verify(
        () => mockDio.get<Map<String, dynamic>>(
          'apod',
          queryParameters: {'date': '2024-10-24'},
        ),
      ).called(1);
    });

    test('fetchApodRange success should return List of ApodDto', () async {
      when(
        () => mockDio.get<List<dynamic>>(
          'apod',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: [
            ApodFixtures.imageResponse,
            ApodFixtures.videoResponse,
          ],
          statusCode: 200,
          requestOptions: RequestOptions(path: 'apod'),
        ),
      );

      final result = await datasource.fetchApodRange(startDate: '2024-10-20');

      expect(result, hasLength(2));
      expect(result[0].mediaType, 'image');
      expect(result[1].mediaType, 'video');
    });

    test('fetchApod should throw ApodRateLimited on 403 status code', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(),
          ),
        ),
      );

      expect(
        () => datasource.fetchApod(),
        throwsA(isA<ApodRateLimited>()),
      );
    });

    test('fetchApod should throw ApodNotFound on 404 status code', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(),
          ),
        ),
      );

      expect(
        () => datasource.fetchApod(),
        throwsA(isA<ApodNotFound>()),
      );
    });

    test('fetchApod should throw ApodServerError on 500 status code', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(),
          ),
        ),
      );

      expect(
        () => datasource.fetchApod(),
        throwsA(isA<ApodServerError>()),
      );
    });

    test('fetchApod should throw ApodTimeout on DioException timeout', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(
        () => datasource.fetchApod(),
        throwsA(isA<ApodTimeout>()),
      );
    });

    test('fetchApod should throw ApodNoConnection on DioException connection error', () async {
      when(
        () => mockDio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        () => datasource.fetchApod(),
        throwsA(isA<ApodNoConnection>()),
      );
    });
  });
}
