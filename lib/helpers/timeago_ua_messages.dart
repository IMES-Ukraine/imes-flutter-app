import 'package:timeago/timeago.dart' as timeago;

class UaMessages implements timeago.LookupMessages {
  String prefixAgo() => '';

  String prefixFromNow() => 'через';

  String suffixAgo() => 'назад';

  String suffixFromNow() => '';

  String lessThanOneMinute(int seconds) => 'хвилину';

  String aboutAMinute(int minutes) => 'хвилину';

  String minutes(int minutes) => '$minutes хвилин';

  String aboutAnHour(int minutes) => 'час';

  String hours(int hours) => _is234(hours) ? '$hours часа' : '$hours годин';

  String aDay(int hours) => 'день';

  String days(int days) => _is234(days) ? '$days дні' : '$days днів';

  String aboutAMonth(int days) => 'місяць';

  String months(int months) => _is234(months) ? '$months місяці' : '$months місяців';

  String aboutAYear(int year) => 'рік';

  String years(int years) => _is234(years) ? '$years року' : '$years років';

  String wordSeparator() => ' ';

  bool _is234(int v){
    var mod = v % 10;
    return (mod == 2 || mod == 3 || mod == 4) && (v / 10) != 1;
  }
}