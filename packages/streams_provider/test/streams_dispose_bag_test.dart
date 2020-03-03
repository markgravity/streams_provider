import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:streams_provider/src/mutable_value_stream.dart';
import 'package:streams_provider/src/streams_dispose_bag.dart';

class MockMutableValueStream extends Mock implements MutableValueStream {}
void main() {
  //
  final val1 = MockMutableValueStream();
  final val2 = MockMutableValueStream();
  final bag = StreamsDisposeBag([val1,val2]);

  test("#1 Dipose the bag, all sinks should call close()", () {
    bag.dispose();
    verify(val1.close());
    verify(val2.close());
  });

  test("#2 Re-add an exists sink, it's should call close() once", () {
    bag.add(val1);
    bag.dispose();
    verify(val1.close()).called(1);
  });
}