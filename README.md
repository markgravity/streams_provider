# Streams Provider

![Coverage](https://raw.githubusercontent.com/markgravity/stream_provider/master/coverage_badge.svg?sanitize=true) [![GitHub issues](https://img.shields.io/github/issues/markgravity/stream_provider)](https://github.com/markgravity/stream_provider/issues) [![GitHub stars](https://img.shields.io/github/stars/markgravity/stream_provider)](https://github.com/markgravity/stream_provider/stargazers) [![GitHub license](https://img.shields.io/github/license/markgravity/object_mapper)](https://github.com/markgravity/stream_provider/blob/master/LICENSE)

------

It provides an elegant and effectively ways to use stream in Provider.

## Streams Widgets
**StreamsProvider** is a Flutter widget which provides a provider to its children via `Provider.of<T>(context)`. It is used as a dependency injection (DI) widget so that a single instance of a provider can be provided to multiple widgets within a subtree.

In most cases, `StreamsProvider` should be used to create new provider which will be made available to the rest of the subtree. In this case, since `StreamsProvider` is responsible for creating the provider, it will automatically handle closing the provider.

```dart
StreamsProvider(
  create: (BuildContext context) => ProviderA(),
  child: ChildA(),
);
```

In some cases, `StreamsProvider` can be used to provide an existing provider to a new portion of the widget tree. This will be most commonly used when an existing provider needs to be made available to a new route. In this case, `StreamsProvider` will not automatically close the bloc since it did not create it.

```dart
StreamsProvider.value(
  value: StreamsProvider.of<ProviderA>(context),
  child: ScreenA(),
);
```

then from either ChildA, or ScreenA we can retrieve ProviderA with:

// with extensions
`context.provider<ProviderA>();`

// without extensions
`StreamsProvider.of<ProviderA>(context)`

**StreamsSelector** is a Flutter widget which select streams from a provider and invokes the builder in response to signal emits in the selector stream.

```dart
StreamsSelector<ProviderA, DataType>(
  selector: (context, provider) {
     // select streams from ProviderA
  },
  builder: (context, data, child) {
    // return widget here based on selector stream emits
  },
)
```

**StreamsListener** is a Flutter widget which takes a StreamsWidgetListener and a selector and invokes the listener in response to signal emits in the selector.  It should be used for functionality that needs to occur once per signal emit such as navigation, showing a SnackBar, showing a Dialog, etc...
listener is only called once for each signal emit.

```dart
StreamsListener<ProviderA, DataType>(
  selector: (context, provider) {
     // select streams from ProviderA
  },
  listener: (context, data) {
    // do stuff here based on data changes
  },
  child: Container(),
)
```

# Usage #
Lets take a look at how to use `StreamsSelector` to hook up a `CounterPage` widget to a `CounterProvider`.
# counter_provider.dart #
```dart
class CounterProvider implements StreamsProvidable {
  final _counter = MutableValueStream<int>(0);
  ValueStream<int> counter => _counter;

  void incrementCounter() {
    _counter.value++;
  }

  void decrementCounter() {
    _counter.value—;
  }
}
```

# counter_page.dart #
```dart
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterProvider counterProvider = context.provider<CounterProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: StreamsSelector<CounterProvider, int>(
        selector: (context, provider) => provider.counter,
        builder: (context, count, child) {
          return Center(
            child: Text(
              '$count',
              style: TextStyle(fontSize: 24.0),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                counterProvider.incrementCounter();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.remove),
              onPressed: () {
                counterProvider.decrementCounter();
              },
            ),
          ),
        ],
      ),
    );
  }
}
```