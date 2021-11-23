import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:imes/models/balance_card.dart';
import 'package:imes/models/banner_card.dart';
import 'package:imes/models/withdraw_history.dart';
import 'package:imes/resources/repository.dart';

enum HistoryState {
  LOADED,
  LOADING,
  ERROR,
}

enum HistorySorting { asc, desc }

extension HistorySortingExt on HistorySorting {
  String get asString => this == HistorySorting.asc ? 'asc' : 'desc';
  String get toLocalizedString =>
      this == HistorySorting.asc ? 'від найстаріших' : 'від найновіших';
}

class HistoryNotifier with ChangeNotifier {
  HistoryState _state;

  int _cardsTotal = 0;
  int _cardsLastPage = 0;
  List<BalanceCard> _cardsItems = [];

  int _total = 0;
  int _lastPage = 0;
  List<WithdrawHistory> _items = [];
  BannerCard _bannerCard = BannerCard.empty();
  HistorySorting _sorting = HistorySorting.desc;

  HistoryNotifier({HistoryState state = HistoryState.LOADING}) : _state = state;

  int get total => _total;

  HistoryState get state => _state;

  List<WithdrawHistory> get items => _items;

  int get cardsTotal => _cardsTotal;

  List<BalanceCard> get cardsItems => _cardsItems;

  BannerCard get bannerCard => _bannerCard;

  HistorySorting get sorting => _sorting;

  void changeSorting(HistorySorting sorting) {
    if (sorting != _sorting) {
      _sorting = sorting;
      notifyListeners();
    }
  }

  Future loadCards() async {
    _state = HistoryState.LOADING;
    notifyListeners();
    try {
      final response =
          await Repository().api.getBalanceCards('', _sorting.asString);
      if (response != null) {
        _cardsTotal = response.body.data.total;
        _cardsLastPage = response.body.data.lastPage;
        _cardsItems = response.body.data.data;
      }
      _state = HistoryState.LOADED;
      notifyListeners();
    } catch (e) {
      _state = HistoryState.ERROR;
      notifyListeners();
    }
  }

  Future load() async {
    _state = HistoryState.LOADING;
    notifyListeners();

    try {
      final futures = await Future.wait([
        Repository().api.getBalanceCards('', _sorting.asString),
        Repository().api.getBalanceBannerCard()
      ]);
      final _cardsResponse = futures[0] as Response<BalanceCardResponse>;
      final _bannerResponse = futures[1] as Response<BannerCardResponse>;
      if (_cardsResponse != null) {
        _cardsTotal = _cardsResponse.body.data.total;
        _cardsLastPage = _cardsResponse.body.data.lastPage;
        _cardsItems = _cardsResponse.body.data.data;
      }
      _bannerCard = _bannerResponse.body.data;
      _state = HistoryState.LOADED;
      notifyListeners();
    } catch (e) {
      _state = HistoryState.ERROR;
      notifyListeners();
    }
  }

  Future loadHistory() async {
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
        // page: ++_lastPage,
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
