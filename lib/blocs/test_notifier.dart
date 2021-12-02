import 'package:flutter/foundation.dart';
import 'package:imes/models/submit_test_data.dart';
import 'package:imes/models/test.dart';
import 'package:imes/models/test_answer.dart';
import 'package:imes/models/test_answer_data.dart';
import 'package:imes/resources/repository.dart';

enum TestState {
  LOADED,
  ERROR,
  LOADING,
}

class TestNotifier with ChangeNotifier {
  TestState _state;

  Test _test;

  TestNotifier({TestState state = TestState.LOADING}) : _state = state;

  TestState get state => _state;

  Test get test => _test;

  Future<int> load(num id) async {
    try {
      final response = await Repository().api.test(id);
      if (response.statusCode == 200) {
        _test = response.body.data.first;
        _state = TestState.LOADED;
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
      _state = TestState.ERROR;
      notifyListeners();
    }

    return _test?.duration ?? 0;
  }

  Future<SubmitTestData> postAnswer(
      int testId, List<String> answers, Duration duration) async {
    final response = await Repository().api.submitTests(
          TestAnswerData(
            data: [TestAnswer(id: testId, variant: answers)],
            seconds: duration.inSeconds,
          ),
        );
    return response.body.data;
  }

  Future<SubmitTestData> postAnswers(
      List<TestAnswer> answers, Duration duration) async {
    final response = await Repository().api.submitTests(
          TestAnswerData(
            data: answers,
            seconds: duration.inSeconds,
          ),
        );
    return response.body.data;
  }
}
