import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:imes/models/user.dart';

import 'package:imes/resources/repository.dart';

final balanceNotifierProvider = ChangeNotifierProvider((ref) => BalanceNotifier());

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

  void onCommentChanged(String value) {
    _comment = value;
  }

  void onAmountChanged(String value) {
    _amount = int.parse(value);
  }

  void chooseType(String type) {
    _type = type;
    notifyListeners();
  }

  Future<User> submit({int amount, String comment, String type}) async {
    _state = BalanceState.PROCESSING;
    notifyListeners();

    final response = await Repository().api.withdraw(amount: amount, comment: comment, type: type);

    _state = BalanceState.WITHDRAW;
    notifyListeners();

    return response.data.user;
  }

  void resetState() {
    _state = BalanceState.WITHDRAW;
    notifyListeners();
  }
}
