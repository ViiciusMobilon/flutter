import 'package:dio/dio.dart';
import 'package:projeto_principal/data/config.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: URLAPI,
      connectTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
      },
    ),
  );
}
