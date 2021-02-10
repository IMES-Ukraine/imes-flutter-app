import 'package:imes/models/reading_status.dart';
import 'package:imes/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'read_blog_block_data.g.dart';


@JsonSerializable()
class ReadBlogBlockData {
  final User user;
  final ReadingStatus readingStatus;

  ReadBlogBlockData({this.user, this.readingStatus});

  factory ReadBlogBlockData.fromJson(Map<String, dynamic> json) =>
      _$ReadBlogBlockDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReadBlogBlockDataToJson(this);
}
