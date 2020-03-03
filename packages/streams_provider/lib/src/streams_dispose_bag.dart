class StreamsDisposeBag {
  StreamsDisposeBag(List<Sink> sinks) : _sinks = sinks ?? [];

  //
  List<Sink> _sinks;

  void add(Sink sink) {
    if (_sinks.contains(sink)) return;
    _sinks.add(sink);
  }

  Future<void> dispose() {
    return Future.wait(_sinks.map((o) async => o.close()));
  }
}