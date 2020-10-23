// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$RestClient extends RestClient {
  _$RestClient([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  final definitionType = RestClient;

  Future<Response<LoginResponse>> login(String login, String password) {
    final $url = 'https://echo.myftp.org/api/auth/login';
    final $body = {'login': login, 'password': password};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<LoginResponse, LoginResponse>($request);
  }

  Future<Response<ProfileResponse>> profile() {
    final $url = 'https://echo.myftp.org/api/v1/profile';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<ProfileResponse, ProfileResponse>($request);
  }

  Future<Response<ProfileResponse>> submitPassword(String password) {
    final $url = 'https://echo.myftp.org/api/v1/profile/password';
    final $body = {'password': password};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ProfileResponse, ProfileResponse>($request);
  }

  Future<Response<BlogsResponse>> blogs(
      {int page = 0, int count = 10, int type = 1}) {
    final $url = 'https://echo.myftp.org/api/v1/blog';
    final Map<String, dynamic> $params = {
      'page': page,
      'count': count,
      'type': type
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<BlogsResponse, BlogsResponse>($request);
  }

  Future<Response<BlogResponse>> blog(num id) {
    final $url = 'https://echo.myftp.org/api/v1/blog/${id}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BlogResponse, BlogResponse>($request);
  }

  Future<Response<AnalyticsResponse>> analytics(
      {String date, int page = 0, int count = 10}) {
    final $url = 'https://echo.myftp.org/api/v1/analytics';
    final Map<String, dynamic> $params = {
      'date': date,
      'page': page,
      'count': count
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<AnalyticsResponse, AnalyticsResponse>($request);
  }

  Future<Response<BasicResponse>> postAnalytics(
      {String id, int grams = 10, int count = 1, String creationTime}) {
    final $url = 'https://echo.myftp.org/api/v1/analytics';
    final $body = {
      'photo_id': id,
      'grams': grams,
      'count': count,
      'creation_time': creationTime
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BasicResponse, BasicResponse>($request);
  }

  Future<Response<NotificationsResponse>> notifications(
      {int page = 0, int count = 10}) {
    final $url = 'https://echo.myftp.org/api/v1/notifications';
    final Map<String, dynamic> $params = {'page': page, 'count': count};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<NotificationsResponse, NotificationsResponse>($request);
  }

  Future<Response> deleteNotification(num id) {
    final $url = 'https://echo.myftp.org/api/v1/notifications/${id}';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  Future<Response<ProfileResponse>> withdraw(
      {int amount = 0, String comment, String type}) {
    final $url = 'https://echo.myftp.org/api/v1/profile/withdraw';
    final $body = {'total': amount, 'comment': comment, 'type': type};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ProfileResponse, ProfileResponse>($request);
  }

  Future<Response<WithdrawHistoryResponse>> withdrawHistory(
      {int page = 0, int count = 10}) {
    final $url = 'https://echo.myftp.org/api/v1/withdraw';
    final Map<String, dynamic> $params = {'page': page, 'count': count};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client
        .send<WithdrawHistoryResponse, WithdrawHistoryResponse>($request);
  }

  Future<Response<BasicResponse>> submitToken({String token}) {
    final $url = 'https://echo.myftp.org/api/v1/profile/token';
    final $body = {'token': token};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<BasicResponse, BasicResponse>($request);
  }

  Future<Response<BasicResponse>> blogCallback(num id) {
    final $url = 'https://echo.myftp.org/api/v1/blog/${id}/callback';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<BasicResponse, BasicResponse>($request);
  }

  Future<Response<TestsResponse>> tests(
      {int page = 0, int count = 10, int type = 1}) {
    final $url = 'https://echo.myftp.org/api/v1/tests';
    final Map<String, dynamic> $params = {
      'page': page,
      'count': count,
      'type': type
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<TestsResponse, TestsResponse>($request);
  }

  Future<Response<TestResponse>> test(num id) {
    final $url = 'https://echo.myftp.org/api/v1/tests/${id}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<TestResponse, TestResponse>($request);
  }

  Future<Response> submitTests(TestAnswerData data) {
    final $url = 'https://echo.myftp.org/api/v1/tests/submit';
    final $body = data;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}
