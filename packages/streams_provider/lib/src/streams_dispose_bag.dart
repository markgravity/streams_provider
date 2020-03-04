/// A class contains sinks that will be closed
/// when [dispose] get called
class StreamsDisposeBag {
  StreamsDisposeBag(List<Sink> sinks) : _sinks = sinks ?? [];

  //
  List<Sink> _sinks;

  /// A function that add a new [Sink] into the list
  ///
  /// The sink that already added will be skipped
  void add(Sink sink) {
    if (_sinks.contains(sink)) return;
    _sinks.add(sink);
  }

  // A function that will close all [Sink] that added
  Future<void> dispose() {
    return Future.wait(_sinks.map((o) async => o.close()));
  }
}