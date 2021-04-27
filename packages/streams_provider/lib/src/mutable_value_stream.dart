import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// A wrapped [BehaviorSubject] class that provides
/// a friendly way to work with [BehaviorSubject]
///
/// It's a mutable [ValueStream] allows to set and get [MutableValueStream.value]
class MutableValueStream<T> extends StreamView<T>
    implements ValueStream<T>, Sink<T> {
  factory MutableValueStream(T value) {
    // ignore: close_sinks
    final subject = BehaviorSubject<T>.seeded(value);
    return MutableValueStream._(subject);
  }

  MutableValueStream._(BehaviorSubject<T> subject)
      : _subject = subject,
        super(subject.stream);

  //
  final BehaviorSubject<T> _subject;

  // ValueStream
  bool get hasValue => _subject.hasValue;

  /// Set and emit the new value
  T? get value => _subject.value;

  @Deprecated("Use MutableValueStream.value instead")
  set value(T? newValue) => _subject.add(newValue!);

  // Sink
  void add(T data) {
    _subject.add(data);
  }

  Future<void> close() {
    return _subject.close();
  }

  @override
  ErrorAndStackTrace? get errorAndStackTrace => throw UnimplementedError();

  @override
  ValueWrapper<T>? get valueWrapper => _subject.valueWrapper;
}
