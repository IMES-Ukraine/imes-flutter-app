import 'package:flutter/foundation.dart';
import 'package:pharmatracker/models/test_answer.dart';
import 'package:pharmatracker/models/test_answer_data.dart';
import 'package:pharmatracker/resources/repository.dart';

class TestNotifier with ChangeNotifier {
  String selectedVarint;

  void select(String variant) {
    selectedVarint = variant;
    notifyListeners();
  }

  Future postAnswer(int testId, String testVariant) async {
    final response =
        await Repository().api.submitTests(TestAnswerData(data: [TestAnswer(id: testId, variant: testVariant)]));
  }
}
