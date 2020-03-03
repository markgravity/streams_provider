import 'package:flutter/cupertino.dart';
import 'package:streams_provider/src/streams_providable.dart';

abstract class StreamsListenable0<T> {
  //
  Stream<T> selector(BuildContext context);
  void handler(BuildContext context, T data);
}

abstract class StreamsListenable<P extends StreamsProvidable, T> {
  //
  Stream<T> selector(BuildContext context, P provider);
  void handler(BuildContext context, P provider, T data);
}

abstract class StreamsListenable2<P1 extends StreamsProvidable, P2 extends StreamsProvidable, T> {
  //
  Stream<T> selector(BuildContext context, P1 provider1, P2 provider2);
  void handler(BuildContext context, P1 provider1, P2 provider2, T data);
}