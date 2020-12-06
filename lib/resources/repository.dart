import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:imes/resources/auth.dart';
import 'package:imes/resources/api.dart';

// final repositoryProvider = Provider((_) => Repository(baseUrl: EnvironmentConfig.BASE_URL));

class Repository {
  static final Repository _instance = Repository._internal();

  Dio _dio;

  RestClient _api;
  RestClient get api => _api;

  AuthClient _auth;
  AuthClient get auth => _auth;

  factory Repository() => _instance;

  Repository._internal() : _dio = Dio() {
    // _dio.interceptors.add(LogInterceptor());
    // _dio.transformer = FlutterTransformer();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        final storage = FlutterSecureStorage();
        final authToken = await storage.read(key: '__AUTH_TOKEN_');
        if (authToken != null) options.headers['Authorization'] = 'Bearer $authToken';
        return options;
      },
      onResponse: (Response response) async {
        if (response.statusCode == 418) {
          return _dio.reject('Authorization failed.');
        }
        if (response.data.containsKey('token') && response.data['token'] != null) {
          final storage = FlutterSecureStorage();
          await storage.write(
            key: '__AUTH_TOKEN_',
            value: response.data['token'],
          );
        }
        return response;
      },
      onError: (DioError e) {
        print(e.request.uri);
        return e;
      },
    ));

    _api = RestClient(_dio);
    _auth = AuthClient(_dio);
  }
}
