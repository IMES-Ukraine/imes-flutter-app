import 'package:json_annotation/json_annotation.dart';

import 'analytics.dart';
import 'pageable.dart';

part 'analytics_page.g.dart';

@JsonSerializable()
class AnalyticsPage extends Pageable {
  List<Analytics> data;

  AnalyticsPage(
      {int currentPage,
        this.data,
        int from,
        int to,
        int total,
        int lastPage,
        int perPage})
      : super(
    currentPage: currentPage,
    from: from,
    to: to,
    total: total,
    lastPage: lastPage,
//    perPage: perPage,
  );

  factory AnalyticsPage.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsPageFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticsPageToJson(this);
}
