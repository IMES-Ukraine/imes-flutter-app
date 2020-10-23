import 'package:flutter/foundation.dart';

import 'package:imes/models/user.dart';

import 'package:imes/resources/repository.dart';

enum BalanceState {
  WITHDRAW,
  PROCESSING,
  HISTORY,
}

class BalanceNotifier extends ChangeNotifier {
  BalanceState _state = BalanceState.WITHDRAW;

  String _type;
  int _amount;
  String _comment;

  BalanceState get state => _state;

  String get type => _type;

  onCommentChanged(String value) {
    _comment = value;
  }

  onAmountChanged(String value) {
    _amount = int.parse(value);
  }

  chooseType(String type) {
    _type = type;
    notifyListeners();
  }

  Future<User> submit() async {
    _state = BalanceState.PROCESSING;
    notifyListeners();

    final response = await Repository().api.withdraw(amount: _amount, comment: _comment, type: _type);

    _state = BalanceState.WITHDRAW;
    notifyListeners();

    return response.body.data.user;
  }

  void resetState() {
    _state = BalanceState.WITHDRAW;
    notifyListeners();
  }
}
