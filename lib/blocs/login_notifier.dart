import 'package:flutter/foundation.dart';

class LoginNotifier with ChangeNotifier {
  bool _termsValue = false;

  bool get termsAndConditionsValue => _termsValue;

  void changeTermsValue() {
    _termsValue = !_termsValue;
    notifyListeners();
  }
}
