// lib/core/network/dio_client.dart

import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class DioClient {
  DioClient._();

  static Dio? _instance;

  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (obj) => debugPrint('[Dio] $obj'),
      ),
    );

    return dio;
  }
}

void debugPrint(String msg) => print(msg);
