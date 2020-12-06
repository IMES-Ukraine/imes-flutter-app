import 'dart:async';
import 'package:imes/models/verify_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'auth.g.dart';

@RestApi(baseUrl: 'http://echo.myftp.org:6666')
abstract class AuthClient {
  factory AuthClient(Dio dio, {String baseUrl}) = _AuthClient;

  @POST('/api/auth')
  Future<HttpResponse> auth(
    @Field('phone') String phone,
  );

  @POST('/api/verify')
  Future<VerifyResponse> verify({
    @Field('phone') String phone,
    @Field('code') String code,
    @Field('deviceId') String deviceId,
    @Field('deviceName') String deviceName,
  });
}
