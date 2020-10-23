import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ValueNotifier<Duration> useCountDownValueNotifier(BuildContext context, [Duration initialDuration = const Duration()]) {
  final result = useValueNotifier(initialDuration);
  use(_TestTimer(result));
  return result;
}

class _TestTimer extends Hook<void> {
  final ValueNotifier<Duration> valueNotifier;

  const _TestTimer(this.valueNotifier);

  @override
  _TestTimerState createState() => _TestTimerState();
}

class _TestTimerState<R> extends HookState<void, _TestTimer> {
  Timer _timer;

  @override
  void initHook() {
    super.initHook();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (hook.valueNotifier.value != const Duration()) {
        hook.valueNotifier.value -= const Duration(seconds: 1);
      }
    });
  }

  @override
  void build(BuildContext context) {}

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
