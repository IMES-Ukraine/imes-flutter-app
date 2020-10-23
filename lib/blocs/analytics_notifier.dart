import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

import 'package:imes/models/analytics.dart';

import 'package:imes/resources/repository.dart';

enum AnalyticsState {
  LOADED,
  ERROR,
  LOADING,
}

class AnalyticsNotifier with ChangeNotifier {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  AnalyticsState _state;

  DateTime _date;

  int _total = 0;
  int _lastPage = 0;
  List<Analytics> _analytics = [];

  AnalyticsNotifier({AnalyticsState state = AnalyticsState.LOADING}) : _state = state;

  int get total => _total;

  DateTime get date => _date;

  AnalyticsState get state => _state;

  List<Analytics> get analytics => _analytics;

  Future load(DateTime date) async {
    _state = AnalyticsState.LOADING;
    _date = date ?? _date;
    notifyListeners();

    try {
      final response = await Repository().api.analytics(date: dateFormat.format(_date));
      if (response.statusCode == 200) {
        final analyticsPage = response.body.data;
        _analytics = analyticsPage?.data ?? [];
        _total = analyticsPage?.total ?? 0;
        _lastPage = analyticsPage?.currentPage ?? 0;

        _state = AnalyticsState.LOADED;
        notifyListeners();
      }
    } catch (e) {
      _state = AnalyticsState.ERROR;
      notifyListeners();
    }
  }

  Future loadNext() async {
//    _state = AnalyticsState.LOADING;
//    notifyListeners();

    final response = await Repository().api.analytics(
          date: dateFormat.format(_date),
          page: ++_lastPage,
        );
    if (response.statusCode == 200) {
      final analyticsPage = response.body.data;
      final analytics = _analytics.toSet()..addAll(analyticsPage?.data ?? []);
      _analytics = analytics.toList();
      _total = analyticsPage?.total ?? _total;
      _lastPage = analyticsPage?.currentPage ?? _lastPage;

      _state = AnalyticsState.LOADED;
      notifyListeners();
    }
  }
}
