import 'dart:async';

/// A class contains sinks that will be closed
/// when [dispose] get called
class StreamsDisposeBag {
  StreamsDisposeBag(List disposables)
      : _disposables = disposables
                .map(
                  (o) => _StreamsDisposable(o),
                )
                .toList() ??
            [];

  //
  List<_StreamsDisposable> _disposables;

  /// A function that add a new [Sink] into the list
  ///
  /// The sink that already added will be skipped
  void add(disposable) {
    if (_disposables.map((o) => o.object).contains(disposable)) return;
    _disposables.add(_StreamsDisposable(disposable));
  }

  // A function that will close all [Sink] that added
  Future<void> dispose() {
    return Future.wait(_disposables.map((o) => o.dispose()));
  }
}

class _StreamsDisposable {
  _StreamsDisposable(this.object) : assert(object is Sink || object is StreamSubscription);

  //
  final dynamic object;

  Future<void> dispose() async {
    // Sink
    if (object is Sink) {
      (object as Sink).close();
    }

    // Stream Subscription
    if (object is StreamSubscription) {
      (object as StreamSubscription).cancel();
    }
  }
}
