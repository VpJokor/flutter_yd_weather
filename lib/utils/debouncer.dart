import 'dart:async';

import 'log.dart';

class Debouncer {
  final Duration delay;
  Completer? _lastCompleter;
  Timer? _timer;
  bool _exec = true;

  Debouncer({required this.delay});

  void run(Function action) {
    // 如果之前的操作还没有完成，取消它
    if (_lastCompleter != null && !_lastCompleter!.isCompleted) {
      _exec = false;
      _lastCompleter!.completeError('Cancelled');
    }

    _lastCompleter = Completer();

    // 重置计时器
    _timer?.cancel();
    if (_exec) {
      action();
    }
    _timer = Timer(delay, () {
      _exec = true;
      _lastCompleter!.complete();
    });

    // 处理取消操作
    _lastCompleter!.future.catchError((error) {
      Log.e('操作被取消');
    });
  }
}
