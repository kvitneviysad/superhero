// lib/core/network/dio_client.dart

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  DioClient._();
  static Dio? _instance;
  static Dio? _imageInstance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio get imageClient {
    _imageInstance ??= Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.bytes,
      ),
    );
    return _imageInstance!;
  }


  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.superheroapi.com/api.php/60e797fb087d5fdb4a729d88bf9b2213/',
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint('[Dio] $obj'),
        ),
      );
    }

    return dio;
  }
}