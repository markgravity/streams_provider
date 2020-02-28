import 'package:rxdart/rxdart.dart';

// IterableStream
extension IterableStream<T extends Iterable<Stream>> on T {
  Stream<Iterable<R>> combineLatest<R>() {
    return CombineLatestStream<dynamic, Iterable<R>>(this, (o) => o as Iterable<R>);
  }

  Stream<R> merge<R>() {
    return MergeStream<R>(this as Iterable<Stream<R>>);
  }
  
  Stream<Iterable<R>> zip<R>() {
    return ZipStream<dynamic,Iterable<R>>(this, (o) => o as Iterable<R>);
  }
}

// ListStream
extension ListStream<T extends List<Stream>> on T {
  Stream<List<R>> combineLatest<R>() {
    return CombineLatestStream<dynamic, List<R>>(this, (o) => o as List<R>);
  }

  Stream<R> merge<R>() {
    return MergeStream<R>(this as List<Stream<R>>);
  }

  Stream<List<R>> zip<R>() {
    return ZipStream<dynamic,List<R>>(this, (o) => o as List<R>);
  }
}

// StreamIterable
extension StreamIterable<T extends Stream<Iterable>> on T {
  Stream<bool> mapEvery<E>(bool test(E element)) {
    return this.map((o) => o.every(test));
  }
}
