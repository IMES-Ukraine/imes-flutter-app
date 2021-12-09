import 'package:flutter/foundation.dart';
import 'package:imes/models/blog.dart';
import 'package:imes/resources/repository.dart';
import 'package:url_launcher/url_launcher.dart';

enum BlogState {
  LOADED,
  ERROR,
  LOADING,
}

class BlogNotifier with ChangeNotifier {
  BlogState _state;

  Blog _blog;

  List<Blog> _popular;

  BlogNotifier({BlogState state = BlogState.LOADING}) : _state = state;

  BlogState get state => _state;

  Blog get blog => _blog;

  List<Blog> get popular => _popular;

  Future load(num id) async {
    try {
      final response = await Repository().api.blog(id);
      if (response.statusCode == 200) {
        _blog = response.body.data.single;

        final nextResponse = await Repository().api.blogs(count: 5, type: 3);
        if (nextResponse.statusCode == 200) {
          _popular = nextResponse.body.data.data;
        }

        _state = BlogState.LOADED;
        Repository().api.blogCallback(_blog.id);
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
      _state = BlogState.ERROR;
      notifyListeners();
    }
  }

  Future read() async {
    var url = _blog.action;
    if (!_blog.action.startsWith('http')) {
      url = 'https://${_blog.action}';
    }
    if (await canLaunch(url)) {
      launch(url);
      final response = await Repository().api.blogCallback(_blog.id);
    }
  }
}

class BlogRecommendedIndicatorNotifier with ChangeNotifier {
  int current;

  void onPositionChange(int value) {
    current = value;
    notifyListeners();
  }
}
