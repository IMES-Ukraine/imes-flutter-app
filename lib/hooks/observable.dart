import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:observable/observable.dart';

/// Subscribes to a [Observable] and mark the widget as needing build
/// whenever the listener is called.
///
/// See also:
///   * [Observable]
///   * [ValueNotifier]
ValueNotifier<T> useObservable<T extends Observable>(ValueNotifier<T> observable) {
  use(_ObservableHook(observable));
  return observable;
}

class _ObservableHook extends Hook<void> {
  const _ObservableHook(this.observable) : assert(observable != null, 'observable cannot be null');

  final ValueNotifier<Observable> observable;

  @override
  _ObservableStateHook createState() => _ObservableStateHook();
}

class _ObservableStateHook extends HookState<void, _ObservableHook> {
  StreamSubscription subscription;

  @override
  void initHook() {
    super.initHook();
    subscription = hook.observable.value.changes.listen(_listener);
  }

  @override
  void didUpdateHook(_ObservableHook oldHook) {
    super.didUpdateHook(oldHook);
    if (hook.observable.value != oldHook.observable.value) {
      subscription.cancel();
      subscription = hook.observable.value.changes.listen(_listener);
    }
  }

  @override
  void build(BuildContext context) {}

  void _listener(records) {
    setState(() {});
  }

  @override
  void dispose() {
    subscription.cancel();
  }

  @override
  String get debugLabel => 'useObservable';

  @override
  Object get debugValue => hook.observable;
}
