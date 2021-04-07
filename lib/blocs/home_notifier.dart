import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class HomeNotifier with ChangeNotifier {
  final PageController controller;

  HomeNotifier({this.controller});

  int _page = 0;

  String _initialPage = '/';

  int get currentPage => _page;

  String get initialPageRoute => _initialPage;

  void changePage(int index, [String initialPage = '/']) {
    // if (index == 3) return;
    if (_page != index) {
      _page = index;
      _initialPage = initialPage;
      controller.jumpToPage(index);
//      controller.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
      notifyListeners();
    }
  }
}
