import 'package:flutter/foundation.dart';

import 'package:pharmatracker/models/withdraw_history.dart';

import 'package:pharmatracker/resources/repository.dart';

enum HistoryState {
  LOADED,
  LOADING,
  ERROR,
}

class HistoryNotifier with ChangeNotifier {
  HistoryState _state;

  int _total = 0;
  int _lastPage = 0;
  List<WithdrawHistory> _items = [];

  HistoryNotifier({HistoryState state = HistoryState.LOADING}) : _state = state;

  int get total => _total;

  HistoryState get state => _state;

  List<WithdrawHistory> get items => _items;

  Future load() async {
    _state = HistoryState.LOADING;
    notifyListeners();

    try {
      final response = await Repository().api.withdrawHistory();
      if (response.statusCode == 200) {
        final historyPage = response.body.data;
        _items = historyPage?.data ?? [];
        _total = historyPage?.total ?? 0;
        _lastPage = historyPage?.currentPage ?? 0;

        _state = HistoryState.LOADED;
        notifyListeners();
      }
    } catch (e) {
      _state = HistoryState.ERROR;
      notifyListeners();
    }
  }

  Future loadNext() async {
//    _state = HistoryState.LOADING;
//    notifyListeners();

    final response = await Repository().api.withdrawHistory(
          page: ++_lastPage,
        );
    if (response.statusCode == 200) {
      final historyPage = response.body.data;
      final items = _items.toSet()..addAll(historyPage?.data ?? []);
      _items = items.toList();
      _total = historyPage?.total ?? _total;
      _lastPage = historyPage?.currentPage ?? _lastPage;

      _state = HistoryState.LOADED;
      notifyListeners();
    }
  }
}
