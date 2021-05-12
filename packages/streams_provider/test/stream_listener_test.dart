import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streams_provider/streams_provider.dart';

class MessageProvider implements StreamsProvidable {
  final message = BehaviorSubject<String>.seeded("");
  late String listenedMessage;

  @override
  Future<void> dispose() {
    return message.close();
  }
}

class App extends StatelessWidget {
  App(this.provider, this.widget);

  final MessageProvider provider;
  final TestWidget widget;
  @override
  Widget build(BuildContext context) {
    return StreamsProvider(
      create: (_) => provider,
      child: widget,
    );
  }
}

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamsListener<MessageProvider, String>(
      selector: (_, provider) => provider.message,
      listener: (context, message) => listener(context, message),
      child: Center(
        child: StreamsSelector<MessageProvider, String>(
          selector: (_, provider) => provider.message,
          builder: (_, message, __) => Text(
            message,
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }

  @visibleForTesting
  void listener(BuildContext context, String message) {
    StreamsProvider.of<MessageProvider>(context).listenedMessage = message;
    setState(() {});
  }
}

void main() {
  //
  final widget = TestWidget();
  final provider = MessageProvider();

  testWidgets(
    "#1 The listener() should be called when selector stream produce a data.",
    (tester) async {
      var message = "it's a message";
      await tester.pumpWidget(App(provider, widget));

      // First message
      provider.message.add(message);
      await tester.pumpAndSettle();
      expect(find.text(message), findsOneWidget);
      expect(provider.listenedMessage, equals(message));

      // Second
      message = "it's a second message";
      provider.message.add(message);
      await tester.pumpAndSettle();
      expect(find.text(message), findsOneWidget);
      expect(provider.listenedMessage, equals(message));
    },
  );
}
