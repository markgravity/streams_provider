import 'package:rxdart/rxdart.dart';

// List Stream
extension ListOfStream<T> on List<Stream<T>> {
  Stream<List<T>> combineLatest() {
    return CombineLatestStream<T, List<T>>(this, (o) => o);
  }

  Stream<T> merge() {
    return MergeStream<T>(this);
  }

  Stream<List<T>> zip() {
    return ZipStream<T, List<T>>(this, (o) => o);
  }
}

// Stream of Iterable
extension StreamOfIterable<T> on Stream<Iterable<T>> {
  Stream<bool> mapEvery(bool test(T element)) {
    return this.map((o) => o.every(test));
  }
}
