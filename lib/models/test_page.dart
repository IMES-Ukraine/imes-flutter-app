import 'package:json_annotation/json_annotation.dart';
import 'package:imes/models/pageable.dart';
import 'package:imes/models/test.dart';

part 'test_page.g.dart';

@JsonSerializable()
class TestPage extends Pageable {
  List<Test> data;

  TestPage({
    int currentPage,
    this.data,
    int from,
    int to,
    int total,
    int lastPage,
    // int perPage,
  }) : super(
          currentPage: currentPage,
          from: from,
          to: to,
          total: total,
          lastPage: lastPage,
          //  perPage: perPage,
        );

  factory TestPage.fromJson(Map<String, dynamic> json) => _$TestPageFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TestPageToJson(this);
}
