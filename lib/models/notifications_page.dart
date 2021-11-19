import 'package:json_annotation/json_annotation.dart';

import 'notification.dart';
import 'pageable.dart';

part 'notifications_page.g.dart';

@JsonSerializable()
class NotificationsPage extends Pageable {
  List<Notification> data;

  NotificationsPage({
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
//    perPage: perPage,
        );

  factory NotificationsPage.fromJson(Map<String, dynamic> json) =>
      _$NotificationsPageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NotificationsPageToJson(this);
}
