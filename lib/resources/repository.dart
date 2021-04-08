import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/io_client.dart';
import 'package:imes/models/read_blog_block_response.dart';
import 'package:imes/models/submit_test_response.dart';
import 'package:imes/models/test_response.dart';
import 'package:imes/models/tests_response.dart';
import 'package:imes/models/upload_file_response.dart';
import 'package:imes/models/verify_response.dart';
import 'package:imes/resources/api.dart';

import 'package:imes/models/basic_response.dart';
import 'package:imes/models/login_response.dart';
import 'package:imes/models/blogs_response.dart';
import 'package:imes/models/blog_response.dart';
import 'package:imes/models/profile_response.dart';
import 'package:imes/models/analytics_response.dart';
import 'package:imes/models/notifications_response.dart';
import 'package:imes/models/withdraw_history_response.dart';
import 'package:imes/models/error_response.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:imes/resources/auth.dart';

class Repository {
  static final Repository _instance = Repository._internal();

  ChopperClient _client;

  RestClient get api => _client.getService<RestClient>();

  AuthClient get auth => _client.getService<AuthClient>();

  factory Repository() {
    return _instance;
  }

  Repository._internal() {
    final converter = JsonSerializableConverter({
      BasicResponse: BasicResponse.fromJsonFactory,
      LoginResponse: LoginResponse.fromJsonFactory,
      BlogsResponse: BlogsResponse.fromJsonFactory,
      BlogResponse: BlogResponse.fromJsonFactory,
      ProfileResponse: ProfileResponse.fromJsonFactory,
      NotificationsResponse: NotificationsResponse.fromJsonFactory,
      AnalyticsResponse: AnalyticsResponse.fromJsonFactory,
      WithdrawHistoryResponse: WithdrawHistoryResponse.fromJsonFactory,
      TestsResponse: TestsResponse.fromJsonFactory,
      TestResponse: TestResponse.fromJsonFactory,
      SubmitTestResponse: SubmitTestResponse.fromJsonFactory,
      VerifyResponse: VerifyResponse.fromJsonFactory,
      UploadFileResponse: UploadFileResponse.fromJsonFactory,
      ReadBlogBlockResponse: ReadBlogBlockResponse.fromJsonFactory,
    });
    final httpClient = HttpClient();
    httpClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    _client = ChopperClient(
      services: [
        // the generated service
        RestClient.create(),
        AuthClient.create()
      ],
      client: IOClient(httpClient),
      converter: converter,
      errorConverter: converter,
      interceptors: [
        authHeader,
        // tokenExpired,s
      ],
    );
  }

  Future<Request> authHeader(Request request) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: '__AUTH_TOKEN_');
    if (token != null) {
      return applyHeader(
        request,
        'Authorization',
        'Bearer $token',
      );
    }
    return request;
  }

  // Future<Response> tokenExpired(Response response) async {
  //   return response;
  // }
}

typedef JsonFactory<T> = T Function(Map<String, dynamic> json);

class JsonSerializableConverter extends JsonConverter {
  final Map<Type, JsonFactory> factories;

  JsonSerializableConverter(this.factories);

  T _decodeMap<T>(Map<String, dynamic> values) {
    /// Get jsonFactory using Type parameters
    /// if not found or invalid, throw error or return null
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! JsonFactory<T>) {
      /// throw serializer not found error;
      return null;
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(List values) => values.where((v) => v != null).map<T>((v) => _decode<T>(v)).toList();

  dynamic _decode<T>(entity) {
    if (entity is Iterable) return _decodeList<T>(entity);

    if (entity is Map) return _decodeMap<T>(entity);

    return entity;
  }

  @override
  Response<ResultType> convertResponse<ResultType, Item>(Response response) {
    // use [JsonConverter] to decode json
    final jsonRes = super.convertResponse(response);

    return jsonRes.replace<ResultType>(body: _decode<Item>(jsonRes.body));
  }

  @override
  // all objects should implements toJson method
  Request convertRequest(Request request) => super.convertRequest(request);

  @override
  Response convertError<ResultType, Item>(Response response) {
    // use [JsonConverter] to decode json
    final jsonRes = super.convertError(response);

    try {
      final response = jsonRes.replace<ErrorResponse>(
        body: ErrorResponse.fromJsonFactory(jsonRes.body),
      );

      return response;
    } catch (e) {
      return response;
    }
  }
}
