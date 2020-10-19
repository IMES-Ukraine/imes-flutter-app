import 'package:flutter/foundation.dart';

class RegisterNotifier with ChangeNotifier {
  bool _termsValue = false;
  bool _doctorValue = false;

  bool get termsAndConditionsValue => _termsValue;

  bool get doctorValue => _doctorValue;

  void changeTermsValue() {
    _termsValue = !_termsValue;
    notifyListeners();
  }

  void changeDoctorValue() {
    _doctorValue = !_doctorValue;
    notifyListeners();
  }
}
