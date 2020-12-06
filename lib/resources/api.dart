import 'dart:async';

import 'package:imes/models/basic_response.dart';
import 'package:imes/models/login_response.dart';
import 'package:imes/models/blogs_response.dart';
import 'package:imes/models/blog_response.dart';
import 'package:imes/models/analytics_response.dart';
import 'package:imes/models/notifications_response.dart';
import 'package:imes/models/profile_response.dart';
import 'package:imes/models/submit_test_response.dart';
import 'package:imes/models/test_answer_data.dart';
import 'package:imes/models/test_response.dart';
import 'package:imes/models/tests_response.dart';
import 'package:imes/models/upload_file_response.dart';
import 'package:imes/models/user_basic_info.dart';
import 'package:imes/models/user_financial_info.dart';
import 'package:imes/models/user_special_info.dart';
import 'package:imes/models/withdraw_history_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'api.g.dart';

@RestApi(baseUrl: 'http://echo.myftp.org')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST('/api/auth/login')
  Future<LoginResponse> login(
    @Field('login') String login,
    @Field('password') String password,
  );

  @GET('/api/v1/profile')
  Future<ProfileResponse> profile();

  @POST('/api/v1/profile/password')
  Future<ProfileResponse> submitPassword(
    @Field('password') String password,
  );

  @GET('/api/v1/blog')
  Future<BlogsResponse> blogs({
    @Query('page') int page = 0,
    @Query('count') int count = 10,
    @Query('type') int type = 1,
  });

  @GET('/api/v1/blog/{id}')
  Future<BlogResponse> blog(@Path('id') num id);

  @GET('/api/v1/analytics')
  Future<AnalyticsResponse> analytics({
    @Query('date') String date,
    @Query('page') int page = 0,
    @Query('count') int count = 10,
  });

  @POST('/api/v1/analytics')
  Future<BasicResponse> postAnalytics({
    @Field('photo_id') String id,
    @Field('grams') int grams = 10,
    @Field('count') int count = 1,
    @Field('creation_time') String creationTime,
  });

  @GET('/api/v1/notifications')
  Future<NotificationsResponse> notifications({
    @Query('page') int page = 0,
    @Query('count') int count = 10,
  });

  @DELETE('/api/v1/notifications/{id}')
  Future<HttpResponse> deleteNotification(@Path('id') num id);

  @POST('/api/v1/profile/withdraw')
  Future<ProfileResponse> withdraw({
    @Field('total') int amount = 0,
    @Field('comment') String comment,
    @Field('type') String type,
  });

  @GET('/api/v1/withdraw')
  Future<WithdrawHistoryResponse> withdrawHistory();

  @POST('/api/v1/profile/token')
  Future<BasicResponse> submitToken({
    @Field('token') String token,
  });

  @GET('/api/v1/blog/{id}/callback')
  Future<BasicResponse> blogCallback(@Path('id') num id);

  @GET('/api/v1/tests')
  Future<TestsResponse> tests({
    @Query('page') int page = 0,
    @Query('count') int count = 10,
    @Query('type') int type = 1,
  });

  @GET('/api/v1/tests/{id}')
  Future<TestResponse> test(@Path('id') num id);

  @POST('/api/v1/tests/submit')
  Future<SubmitTestResponse> submitTests(@Body() TestAnswerData data);

  @POST('/api/v1/profile/verify')
  Future<ProfileResponse> submitProfile(
    @Field('basic_information') UserBasicInfo basicInfo,
    @Field('specialized_information') UserSpecializedInfo specializedInfo,
    @Field('financial_information') UserFinancialInfo financialInfo,
  );

  @MultiPart()
  @POST('/api/v1/profile/image/education_document')
  Future<UploadFileResponse> uploadEducationDoc(@Part(name: 'file') String path);

  @MultiPart()
  @POST('/api/v1/profile/image/avatar')
  Future<UploadFileResponse> uploadProfileImage(@Part(name: 'file') String path);

  @GET('/api/v1/blog/{id}/read/{index}')
  Future<HttpResponse> readBlogBlock({@Path('id') num blogId, @Path('index') num blockIndex});
}
