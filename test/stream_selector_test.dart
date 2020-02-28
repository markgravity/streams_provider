import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_provider/src/mutable_value_stream.dart';
import 'package:stream_provider/src/stream_providable.dart';
import 'package:stream_provider/src/stream_provider.dart';
import 'package:stream_provider/src/stream_selector.dart';

class TestWidget extends StatelessWidget {
  TestWidget(this.message);

  final Stream<String> message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamSelector0<String>(
        selector: (_) => message,
        builder: (_, message, __) => Text(message, textDirection: TextDirection.ltr,),
      ),
    );
  }
}

class MessageProvider implements StreamProvidable {
  final message = MutableValueStream<String>("");

  @override
  Future<void> dispose() {
    return message.close();
  }

}

class App extends StatelessWidget {
  App(this.provider);
  final MessageProvider provider;

  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      create: (_) => provider,
      child: TestWidget2(),
    );
  }
}

class TestWidget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamSelector<MessageProvider,String>(
        selector: (_, provider) => provider.message,
        builder: (_, message, __) => Text(message, textDirection: TextDirection.ltr,),
      ),
    );
  }
}

void main() {
  //

  testWidgets("#1 StreamSelector0", (tester) async {
    final stream = MutableValueStream<String>("");
    final message = "It's a message";
    await tester.pumpWidget(TestWidget(stream));
    stream.value = message;
    await tester.pumpAndSettle();
    expect(find.text(message), findsOneWidget);
  });

  testWidgets("#2 StreamSelector", (tester) async {
    final message = "It's a message";
    final provider = MessageProvider();

    await tester.pumpWidget(App(provider));

    provider.message.value = message;
    await tester.pumpAndSettle();
    expect(find.text(message), findsOneWidget);
  });
}