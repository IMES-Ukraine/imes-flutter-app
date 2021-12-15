import 'package:flutter/foundation.dart';
import 'package:imes/models/test.dart';
import 'package:imes/resources/repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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

  TestsPage _page = TestsPage.NEWS;
  TestsState _state;
  int _total = 0;

  int get total => _total;

  TestsState get state => _state;

  TestsPage get page => _page;

  final _pageSize = 10;

  final PagingController<int, Test> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void dispose() {
    pagingController?.dispose();
    super.dispose();
  }

  void init() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future changePage(TestsPage page) async {
    _page = page;
    _state = TestsState.LOADING;
    notifyListeners();
    return pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      _state = TestsState.LOADING;
      final response = await Repository().api.tests(
            type: page.index + 1,
            page: pageKey,
            count: _pageSize,
          );
      debugPrint('START_OF <<<=========== response ==========>>>');
      debugPrint(response.toString());
      debugPrint('END_OF   <<<=========== response ==========>>>');
      final newItems = response.body.data.data;
      final isLastPage = response.body.data.data.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
      _state = TestsState.LOADED;
    } catch (error) {
      pagingController.error = error;
      _state = TestsState.ERROR;
    }
  }
}
