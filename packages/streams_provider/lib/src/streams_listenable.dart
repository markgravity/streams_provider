import 'package:flutter/cupertino.dart';
import 'package:streams_provider/src/streams_listener.dart';
import 'package:streams_provider/src/streams_providable.dart';

/// A listenable interface for [StreamsListener0]
abstract class StreamsListenable0<T> {
  /// A function that will return a [Stream]
  /// it changes will trigger [handler]
  Stream<T> selector(BuildContext context);

  /// A function will be called selector stream
  /// emits an event
  void handler(BuildContext context, T data);
}

/// A listenable interface for [StreamsListener]
abstract class StreamsListenable<P extends StreamsProvidable, T> {
  //
  Stream<T> selector(BuildContext context, P provider);
  void handler(BuildContext context, P provider, T data);
}

/// A listenable interface for [StreamsListener2]
abstract class StreamsListenable2<P1 extends StreamsProvidable,
    P2 extends StreamsProvidable, T> {
  //
  Stream<T> selector(BuildContext context, P1 provider1, P2 provider2);
  void handler(BuildContext context, P1 provider1, P2 provider2, T data);
}
