import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class HomeNotifier with ChangeNotifier {
  final PageController controller;

  HomeNotifier({this.controller});

  int _page = 0;

  int get currentPage => _page;

  void changePage(int index) {
    if (index == 3) return;
    if (_page != index) {
      _page = index;
      controller.jumpToPage(index);
//      controller.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
      notifyListeners();
    }
  }
}
