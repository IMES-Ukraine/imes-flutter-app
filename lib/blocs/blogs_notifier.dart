import 'package:flutter/foundation.dart';
import 'package:imes/models/blog.dart';
import 'package:imes/resources/repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum BlogsState {
  LOADED,
  ERROR,
  LOADING,
}

enum BlogPage {
  NEWS,
  INFORMATION,
  FAVORITES,
}

class BlogsNotifier with ChangeNotifier {
  BlogsState _state;

  BlogPage _page = BlogPage.NEWS;

  BlogsNotifier({BlogsState state = BlogsState.LOADING}) : _state = state;

  BlogsState get state => _state;

  BlogPage get page => _page;

  final _pageSize = 10;

  final PagingController<int, Blog> pagingController =
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

  Future<void> _fetchPage(int pageKey) async {
    try {
      _state = BlogsState.LOADING;
      final response = await Repository().api.blogs(
            type: page.index + 1,
            page: pageKey,
            count: _pageSize,
          );
      final newItems = response.body.data.data;
      final isLastPage = response.body.data.data.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
      _state = BlogsState.LOADED;
    } catch (error) {
      pagingController.error = error;
      _state = BlogsState.ERROR;
    }
  }

  Future<void> changePage(BlogPage page) async {
    _page = page;
    _state = BlogsState.LOADING;
    notifyListeners();
    pagingController.refresh();
    _fetchPage(0);
  }
}
