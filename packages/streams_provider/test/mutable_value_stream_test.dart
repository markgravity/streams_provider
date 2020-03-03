import 'package:test/test.dart';
import 'package:streams_provider/streams_provider.dart';

void main() {
  //
  MutableValueStream stream;

  tearDown(() {
    stream.close();
  });

  test("#1 hasValue", () {
    stream = MutableValueStream<int>(1);
    expect(stream.hasValue, isTrue);
  });

  test("#2 value getter", () {
    stream = MutableValueStream<int>(1);
    expect(stream.value, equals(1));
  });

  test("#3 value setter", () {
    stream = MutableValueStream<int>(1);
    stream.value = 2;
    expect(stream.value, equals(2));
  });

  test("#4 Empty value", () {
    stream = MutableValueStream<int>();
    expect(stream.hasValue, isFalse);
  });
}
