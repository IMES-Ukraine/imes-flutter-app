import 'package:json_annotation/json_annotation.dart';

import 'withdraw_history.dart';
import 'pageable.dart';

part 'withdraw_page.g.dart';

@JsonSerializable()
class WithdrawPage extends Pageable {
  List<WithdrawHistory> data;

  WithdrawPage({int currentPage, this.data, int from, int to, int total, int lastPage, int perPage})
      : super(
          currentPage: currentPage,
          from: from,
          to: to,
          total: total,
          lastPage: lastPage,
//    perPage: perPage,
        );

  factory WithdrawPage.fromJson(Map<String, dynamic> json) => _$WithdrawPageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WithdrawPageToJson(this);
}
