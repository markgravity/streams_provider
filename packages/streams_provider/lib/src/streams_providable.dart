/// A base interface that all Provider that
/// want to use streams should implement it.
abstract class StreamsProvidable {

  /// A function will be called when widget get dispose
  Future<void> dispose();
}
