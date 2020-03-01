import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// A class that wrapper a BehaviorSubject
/// provides a friendly way to work with BehaviorSubject
class MutableValueStream<T> extends StreamView<T> implements ValueStream<T> {
  factory MutableValueStream(T value) {

    // ignore: close_sinks
    final subject = BehaviorSubject.seeded(value);
    return MutableValueStream._(subject);
  }
  MutableValueStream._(BehaviorSubject<T> subject) : _subject = subject, super(subject.stream);

  //
  final BehaviorSubject _subject;

  // ValueStream
  bool get hasValue => _subject.hasValue;
  T get value => _subject.value;

  /// Set and emit the new value
  set value(T newValue) => _subject.add(newValue);

  Future<void> close() {
    return _subject.close();
  }
}
