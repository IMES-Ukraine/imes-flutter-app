import 'package:json_annotation/json_annotation.dart';

import 'blog.dart';
import 'pageable.dart';

part 'blog_page.g.dart';

@JsonSerializable()
class BlogPage extends Pageable {
  List<Blog> data;

  BlogPage({
    int currentPage,
    this.data,
    int from,
    int to,
    int total,
    int lastPage,
    int perPage,
  }) : super(
          currentPage: currentPage,
          from: from,
          to: to,
          total: total,
          lastPage: lastPage,
//          perPage: perPage,
        );

  factory BlogPage.fromJson(Map<String, dynamic> json) => _$BlogPageFromJson(json);

  Map<String, dynamic> toJson() => _$BlogPageToJson(this);
}
