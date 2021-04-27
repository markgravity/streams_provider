import 'dart:async';

import '../streams_dispose_bag.dart';

extension StreamSubscriptionExtensions<T> on StreamSubscription<T> {
  void disposed({required StreamsDisposeBag by}) {
    by.add(this);
  }
}
