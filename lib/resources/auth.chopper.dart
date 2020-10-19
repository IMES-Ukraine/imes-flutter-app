// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$AuthClient extends AuthClient {
  _$AuthClient([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = AuthClient;

  Future<Response> auth(String phone) {
    final $url = 'http://echo.myftp.org:6666/api/auth';
    final $headers = {'Content-Type': 'application/json'};
    final $body = {'phone': phone};
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response<LoginResponse>> verify(
      {String phone, String code, String deviceId, String deviceName}) {
    final $url = 'http://echo.myftp.org:6666/api/verify';
    final $headers = {'Content-Type': 'application/json'};
    final $body = {
      'phone': phone,
      'code': code,
      'deviceId': deviceId,
      'deviceName': deviceName
    };
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<LoginResponse, LoginResponse>($request);
  }
}
