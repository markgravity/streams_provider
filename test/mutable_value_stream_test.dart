import 'package:test/test.dart';
import 'package:streams_provider/streams_provider.dart';

void main() {
  //
  test("#1 hasValue", () {
    final stream = MutableValueStream<int>(1);
    expect(stream.hasValue, isTrue);
  });

  test("#2 value getter", () {
    final stream = MutableValueStream<int>(1);
    expect(stream.value, equals(1));
  });

  test("#3 value setter", () {
    final stream = MutableValueStream<int>(1);
    stream.value = 2;
    expect(stream.value, equals(2));
  });
}
