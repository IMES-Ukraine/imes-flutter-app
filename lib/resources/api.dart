import "dart:async";
import 'package:chopper/chopper.dart';

import 'package:pharmatracker/models/basic_response.dart';
import 'package:pharmatracker/models/login_response.dart';
import 'package:pharmatracker/models/blogs_response.dart';
import 'package:pharmatracker/models/blog_response.dart';
import 'package:pharmatracker/models/analytics_response.dart';
import 'package:pharmatracker/models/notifications_response.dart';
import 'package:pharmatracker/models/profile_response.dart';
import 'package:pharmatracker/models/test_answer_data.dart';
import 'package:pharmatracker/models/tests_response.dart';
import 'package:pharmatracker/models/withdraw_history_response.dart';

part 'api.chopper.dart';

//@ChopperApi(baseUrl: 'http://185.65.244.189')
// @ChopperApi(baseUrl: 'http://yaris-ls.serveo.net')
@ChopperApi(baseUrl: 'https://echo.myftp.org')
abstract class RestClient extends ChopperService {
  static RestClient create([ChopperClient client]) => _$RestClient(client);

  @multipart
  @Post(path: '/api/auth/login')
  Future<Response<LoginResponse>> login(
    @Field('login') String login,
    @Field('password') String password,
  );

  @Get(path: '/api/v1/profile')
  Future<Response<ProfileResponse>> profile();

  @Get(path: '/api/v1/blog')
  Future<Response<BlogsResponse>> blogs({
    @Query('page') int page = 0,
    @Query('count') int count = 10,
    @Query('type') int type = 1,
  });

  @Get(path: '/api/v1/blog/{id}')
  Future<Response<BlogResponse>> blog(@Path('id') num id);

  @Get(path: '/api/v1/analytics')
  Future<Response<AnalyticsResponse>> analytics({
    @Query('date') String date,
    @Query('page') int page = 0,
    @Query('count') int count = 10,
  });

  @Post(path: '/api/v1/analytics')
  Future<Response<BasicResponse>> postAnalytics({
    @Field('photo_id') String id,
    @Field('grams') int grams = 10,
    @Field('count') int count = 1,
    @Field('creation_time') String creationTime,
  });

  @Get(path: '/api/v1/notifications')
  Future<Response<NotificationsResponse>> notifications({
    @Query('page') int page = 0,
    @Query('count') int count = 10,
  });

  @Delete(path: "/api/v1/notifications/{id}")
  Future<Response> deleteNotification(@Path('id') num id);

  @Post(path: '/api/v1/profile/withdraw')
  Future<Response<ProfileResponse>> withdraw({
    @Field('total') int amount = 0,
    @Field('comment') String comment,
    @Field('type') String type,
  });

  @Get(path: '/api/v1/withdraw')
  Future<Response<WithdrawHistoryResponse>> withdrawHistory({
    @Query('page') int page = 0,
    @Query('count') int count = 10,
  });

  @Post(path: '/api/v1/profile/token')
  Future<Response<BasicResponse>> submitToken({
    @Field('token') String token,
  });

  @Get(path: '/api/v1/blog/{id}/callback')
  Future<Response<BasicResponse>> blogCallback(@Path('id') num id);

  @Get(path: '/api/v1/tests')
  Future<Response<TestsResponse>> tests({
    @Query('page') int page = 0,
    @Query('count') int count = 10,
    @Query('type') int type = 1,
  });

  @Post(path: '/api/v1/tests/submit')
  Future<Response> submitTests(@Body() TestAnswerData data);
}
