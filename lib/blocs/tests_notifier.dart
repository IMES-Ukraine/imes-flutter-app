import 'package:flutter/foundation.dart';
import 'package:imes/models/test.dart';
import 'package:imes/resources/repository.dart';

enum TestsPage {
  NEWS,
  INFORMATION,
}

enum TestsState {
  LOADED,
  ERROR,
  LOADING,
}

class TestsStateNotifier with ChangeNotifier {
  TestsStateNotifier({TestsState state = TestsState.LOADING}) : _state = state;

  int _lastPage = 0;
  TestsPage _page = TestsPage.NEWS;
  TestsState _state;
  List<Test> _tests = [];
  int _total = 0;

  int get total => _total;

  TestsState get state => _state;

  List<Test> get tests => _tests;

  TestsPage get page => _page;

  Future changePage(TestsPage page) async {
    _page = page;
    _state = TestsState.LOADING;
    notifyListeners();
    return load();
  }

  Future load() async {
    try {
      final response = await Repository().api.tests(type: page.index + 1);
      if (response.statusCode == 200) {
        final testsPage = response.body.data;
        _tests = testsPage.data;
        _total = testsPage.total;
        _lastPage = testsPage.currentPage;

        _state = TestsState.LOADED;
        notifyListeners();
      }
    } catch (e) {
      _state = TestsState.ERROR;
      debugPrint(e);
      notifyListeners();
    }
  }

  Future loadNext() async {
//    _state = BlogsState.LOADING;
//    notifyListeners();

    final response = await Repository().api.tests(page: ++_lastPage);
    if (response.statusCode == 200) {
      final testsPage = response.body.data;
      final tests = _tests.toSet()..addAll(testsPage.data);
      _tests = tests.toList();
      _total = testsPage.total;
      _lastPage = testsPage.currentPage;

      _state = TestsState.LOADED;
      notifyListeners();
    }
  }

  void remove(Test test) {
    if (tests.remove(test)) {
      notifyListeners();
    }
  }
}
