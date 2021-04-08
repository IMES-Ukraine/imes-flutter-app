import 'dart:async';
import 'package:chopper/chopper.dart';

import 'package:imes/models/basic_response.dart';
import 'package:imes/models/login_response.dart';
import 'package:imes/models/blogs_response.dart';
import 'package:imes/models/blog_response.dart';
import 'package:imes/models/analytics_response.dart';
import 'package:imes/models/notifications_response.dart';
import 'package:imes/models/profile_response.dart';
import 'package:imes/models/read_blog_block_response.dart';
import 'package:imes/models/submit_test_response.dart';
import 'package:imes/models/test_answer_data.dart';
import 'package:imes/models/test_response.dart';
import 'package:imes/models/tests_response.dart';
import 'package:imes/models/upload_file_response.dart';
import 'package:imes/models/withdraw_history_response.dart';

part 'api.chopper.dart';

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

  @multipart
  @Post(path: '/api/v1/profile/password')
  Future<Response<ProfileResponse>> submitPassword(
    @Field('password') String password,
  );

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

  @Delete(path: '/api/v1/notifications/{id}')
  Future<Response> deleteNotification(@Path('id') num id);

  @Post(path: '/api/v1/profile/withdraw')
  Future<Response<ProfileResponse>> withdraw({
    @Field('total') int amount = 0,
    @Field('comment') String comment,
    @Field('type') String type,
  });

  @Get(path: '/api/v1/withdraw')
  Future<Response<WithdrawHistoryResponse>> withdrawHistory(
      // {
      //   @Query('page') int page = 0,
      //   @Query('count') int count = 10,
      // }
      );

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

  @Get(path: '/api/v1/tests/{id}')
  Future<Response<TestResponse>> test(@Path('id') num id);

  @Post(path: '/api/v1/tests/submit')
  Future<Response<SubmitTestResponse>> submitTests(@Body() TestAnswerData data);

  @Post(path: '/api/v1/profile/verify')
  Future<Response<ProfileResponse>> submitProfile(@Body() Map<String, dynamic> data);

  @multipart
  @Post(path: '/api/v1/profile/image/education_document')
  Future<Response<UploadFileResponse>> uploadEducationDoc(@PartFile('file') String path);

  @multipart
  @Post(path: '/api/v1/profile/image/passport')
  Future<Response<UploadFileResponse>> uploadPassport(@PartFile('file') String path);

  @multipart
  @Post(path: '/api/v1/profile/image/mic_id')
  Future<Response<UploadFileResponse>> uploadMicId(@PartFile('file') String path);

  @multipart
  @Post(path: '/api/v1/profile/image/avatar')
  Future<Response<UploadFileResponse>> uploadProfileImage(@PartFile('file') String path);

  @Get(path: '/api/v1/blog/{id}/read/{index}')
  Future<Response<ReadBlogBlockResponse>> readBlogBlock({@Path('id') num blogId, @Path('index') num blockIndex});

  @Get(path: '/api/v1/agreement/{id}')
  Future<Response<TestResponse>> getAgreement(@Path('id') num testId);

  @Post(path: '/api/v1/agreement/{id}')
  Future<Response> postAgreement(@Path('id') num testId);

  // @Get(path: '/api/notifications/{id}')
  // Future<Response> getNotification(@Path('id') num id);
}
