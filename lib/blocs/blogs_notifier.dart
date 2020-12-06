import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:imes/models/blog.dart';

import 'package:imes/resources/repository.dart';

final blogsNotifierProvider = ChangeNotifierProvider((ref) => BlogsNotifier());

enum BlogsState {
  LOADED,
  ERROR,
  LOADING,
}

enum BlogPage {
  NEWS,
  INFORMATION,
}

class BlogsNotifier with ChangeNotifier {
  BlogsState _state;

  int _total = 0;
  int _lastPage = 0;
  List<Blog> _blogs = [];
  BlogPage _page = BlogPage.NEWS;

  BlogsNotifier({BlogsState state = BlogsState.LOADING}) : _state = state;

  int get total => _total;

  BlogsState get state => _state;

  List<Blog> get blogs => _blogs;

  BlogPage get page => _page;

  Future<void> changePage(BlogPage page) async {
    _page = page;
    _state = BlogsState.LOADING;
    notifyListeners();
    return load();
  }

  Future<void> load() async {
    try {
      final response = await Repository().api.blogs(type: page.index + 1);
      if (response.statusCode == 200) {
        final blogsPage = response.data;
        _blogs = blogsPage.data;
        _total = blogsPage.total;
        _lastPage = blogsPage.currentPage;

        _state = BlogsState.LOADED;
        notifyListeners();
      }
    } catch (e) {
      _state = BlogsState.ERROR;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> loadNext() async {
//    _state = BlogsState.LOADING;
//    notifyListeners();

    final response = await Repository().api.blogs(page: ++_lastPage);
    if (response.statusCode == 200) {
      final blogsPage = response.data;
      final blogs = _blogs.toSet()..addAll(blogsPage.data);
      _blogs = blogs.toList();
      _total = blogsPage.total;
      _lastPage = blogsPage.currentPage;

      _state = BlogsState.LOADED;
      notifyListeners();
    }
  }
}
