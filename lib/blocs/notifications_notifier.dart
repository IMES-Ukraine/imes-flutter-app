import 'package:flutter/foundation.dart';

import 'package:imes/models/notification.dart';

import 'package:imes/resources/repository.dart';

enum NotificationsState {
  LOADED,
  ERROR,
  LOADING,
}

class NotificationsNotifier with ChangeNotifier {
  NotificationsState _state;

  int _total = 0;
  int _lastPage = 0;
  List<Notification> _notifications = [];

  NotificationsNotifier({NotificationsState state = NotificationsState.LOADING}) : _state = state;

  int get total => _total;

  NotificationsState get state => _state;

  List<Notification> get notifications => _notifications;

  Future load() async {
    _state = NotificationsState.LOADING;
    notifyListeners();

    try {
      final response = await Repository().api.notifications();
      if (response.statusCode == 200) {
        final notificationsPage = response.body.data;
        _notifications = notificationsPage?.data ?? [];
        _total = notificationsPage?.total ?? 0;
        _lastPage = notificationsPage?.currentPage ?? 0;

        _state = NotificationsState.LOADED;
        notifyListeners();
      }
    } catch (e) {
      _state = NotificationsState.ERROR;
      notifyListeners();
      rethrow;
    }
  }

  Future loadNext() async {
    final response = await Repository().api.notifications(
          page: ++_lastPage,
        );
    if (response.statusCode == 200) {
      final notificationsPage = response.body.data;
      final notifications = _notifications.toSet()..addAll(notificationsPage?.data ?? []);
      _notifications = notifications.toList();
      _total = notificationsPage?.total ?? _total;
      _lastPage = notificationsPage?.currentPage ?? _lastPage;

      _state = NotificationsState.LOADED;
      notifyListeners();
    }
  }

  Future delete(int index) async {
    final id = _notifications[index].id;
    final response = await Repository().api.deleteNotification(id);
    if (response.statusCode == 200) {
      _notifications.removeWhere((n) => n.id == id);
      _total--;
      notifyListeners();
    }
  }
}
