import 'package:timeago/timeago.dart' as timeago;

class UaMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => 'через';

  @override
  String suffixAgo() => 'тому';

  @override
  String suffixFromNow() => '';

  @override
  String lessThanOneMinute(int seconds) => 'хвилину';

  @override
  String aboutAMinute(int minutes) => 'хвилину';

  @override
  String minutes(int minutes) => '$minutes хвилин';

  @override
  String aboutAnHour(int minutes) => 'час';

  @override
  String hours(int hours) => _is234(hours) ? '$hours часа' : '$hours годин';

  @override
  String aDay(int hours) => 'день';

  @override
  String days(int days) => _is234(days) ? '$days дні' : '$days днів';

  @override
  String aboutAMonth(int days) => 'місяць';

  @override
  String months(int months) => _is234(months) ? '$months місяці' : '$months місяців';

  @override
  String aboutAYear(int year) => 'рік';

  @override
  String years(int years) => _is234(years) ? '$years року' : '$years років';

  @override
  String wordSeparator() => ' ';

  bool _is234(int v) {
    var mod = v % 10;
    return (mod == 2 || mod == 3 || mod == 4) && (v / 10) != 1;
  }
}
