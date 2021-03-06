import 'package:test/test.dart';
import 'package:streams_provider/streams_provider.dart';

void main() {
  //
  // ignore: close_sinks
  BehaviorSubject? a;
  // ignore: close_sinks
  BehaviorSubject? b;

  setUp(() {
    a = BehaviorSubject.seeded(1);
    b = BehaviorSubject.seeded(2);
  });

  test("#1 combineLatest()", () async {
    final stream = [a!, b!].combineLatest();
    expect(
        stream,
        emitsInOrder([
          [1, 2],
          [3, 2],
        ]));
    a!.add(3);
  });

  test("#2 merge()", () async {
    final stream = [a!, b!].merge();
    expect(stream, emitsInOrder([1, 2, 3]));
    b!.add(3);
  });

  test("#3 zip()", () async {
    final stream = [a!, b!].zip();
    expect(
        stream,
        emitsInOrder([
          [1, 2],
          [3, 4],
        ]));
    a!.add(3);
    b!.add(4);
  });

  test("#4 mapEvery()", () async {
    final stream = [a!, b!].combineLatest().mapEvery((o) => o == 1);
    expect(stream, emits(false));
  });
}
