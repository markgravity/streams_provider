import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:streams_provider/streams_provider.dart';

class TestWidget extends StatelessWidget {
  TestWidget(this.message);
  static const textKey = Key("test_widget_text_key");

  late final Stream<String> message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamsSelector0<String>(
        selector: (_) => message,
        builder: (_, message, __) => message != ""
            ? Text(
                message,
                key: textKey,
                textDirection: TextDirection.ltr,
              )
            : SizedBox.shrink(),
      ),
    );
  }
}

class MessageProvider implements StreamsProvidable {
  late final message = BehaviorSubject<String>.seeded("");

  @override
  Future<void> dispose() {
    return message.close();
  }
}

class ErrorProvider implements StreamsProvidable {
  final error = BehaviorSubject<String>.seeded("");

  @override
  Future<void> dispose() {
    return error.close();
  }
}

class App extends StatelessWidget {
  App(this.provider, this.widget, [this.provider2]);

  final ErrorProvider? provider2;
  final MessageProvider provider;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamsProvider(create: (_) => provider),
        StreamsProvider(
          create: (_) => provider2!,
        )
      ],
      child: widget,
    );
  }
}

class TestWidget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamsSelector<MessageProvider, String>(
        selector: (_, provider) => provider.message,
        builder: (_, message, __) => Text(
          message,
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}

class TestWidget3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamsSelector2<MessageProvider, ErrorProvider, String>(
        selector: (_, provider1, provider2) =>
            provider1.message + provider2.error,
        builder: (_, message, __) => Text(
          message,
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}

extension StreamExtension<T extends String> on Stream<T> {
  Stream<T> operator +(other) {
    if (other is String) return this.map((o) => o + other) as Stream<T>;

    if (other is Stream<T>)
      return [this, other].combineLatest().map((o) => o.join("")) as Stream<T>;

    throw AssertionError("Type is not supported");
  }
}

void main() {
  //

  testWidgets("#1 StreamSelector0", (tester) async {
    final stream = BehaviorSubject<String>.seeded("");
    final message = "It's a message";
    await tester.pumpWidget(TestWidget(stream));
    stream.add(message);
    await tester.pumpAndSettle();
    expect(find.text(message), findsOneWidget);
    stream.close();
  });

  testWidgets("#2 StreamSelector", (tester) async {
    final message = "It's a message";
    final provider = MessageProvider();
    final widget = TestWidget2();

    await tester.pumpWidget(App(provider, widget));

    provider.message.add(message);
    await tester.pumpAndSettle();
    expect(find.text(message), findsOneWidget);
  });

  testWidgets("#3 StreamSelector2", (tester) async {
    final message = "It's a message";
    final provider = MessageProvider();
    final provider2 = ErrorProvider();
    final widget = TestWidget3();
    await tester.pumpWidget(App(provider, widget, provider2));

    provider.message.add(message);
    provider2.error.add(message);
    await tester.pumpAndSettle();
    expect(find.text(message + message), findsOneWidget);
  });

  testWidgets("#4 StreamSelector with null value", (tester) async {
    final stream = BehaviorSubject<String>.seeded("null");
    await tester.pumpWidget(TestWidget(stream));
    expect(find.byKey(TestWidget.textKey), findsNothing);

    stream.add("test");
    await tester.pumpAndSettle();
    expect(find.byKey(TestWidget.textKey), findsOneWidget);

    stream.add("");
    await tester.pumpAndSettle();
    expect(find.byKey(TestWidget.textKey), findsNothing);

    stream.close();
  });
}
