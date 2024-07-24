import 'dart:async';
import 'dart:ui';

class Debounce {
  Debounce({
    required this.duration,
  });

  final Duration duration;
  Timer? _timer;

  void call({required VoidCallback callback}) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }
}
