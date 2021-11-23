import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:imes/models/verify_response.dart';

part 'auth.chopper.dart';

//@ChopperApi(baseUrl: 'http://185.65.244.189')
// @ChopperApi(baseUrl: 'http://yaris-ls.serveo.net')
// @ChopperApi(baseUrl: 'https://s.imes.pro/service')
@ChopperApi(baseUrl: 'http://imes.nextdoorcoders.com')
abstract class AuthClient extends ChopperService {
  static AuthClient create([ChopperClient client]) => _$AuthClient(client);

  @Post(
      path: '/service/api/auth', headers: {'Content-Type': 'application/json'})
  Future<Response> auth(@Field('phone') String phone);

  @Post(
      path: '/service/api/verify',
      headers: {'Content-Type': 'application/json'})
  Future<Response<VerifyResponse>> verify({
    @Field('phone') String phone,
    @Field('code') String code,
    @Field('deviceId') String deviceId,
    @Field('deviceName') String deviceName,
  });
}
