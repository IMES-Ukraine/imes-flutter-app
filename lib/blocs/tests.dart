import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:pharmatracker/models/test.dart';
import 'package:pharmatracker/resources/repository.dart';

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
  TestsState _state;

  int _total = 0;
  int _lastPage = 0;
  List<Test> _tests = [];
  TestsPage _page = TestsPage.NEWS;

  TestsStateNotifier({TestsState state = TestsState.LOADING}) : _state = state;

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
}
