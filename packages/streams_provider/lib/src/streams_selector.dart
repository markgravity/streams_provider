import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart' hide StreamProvider;
import 'package:provider/single_child_widget.dart';
import 'streams_provider.dart';

/// A base class for custom [StreamsSelector].
///
/// It works with any [InheritedWidget]. Variants like [StreamsSelector] and
/// [StreamsSelector6] are just syntax sugar to use [StreamsSelector0] with [StreamProvider.of].
class StreamsSelector0<T> extends SingleChildStatefulWidget {
  /// Both `builder` and `selector` must not be `null`.
  StreamsSelector0({
    Key? key,
    required this.selector,
    required this.builder,
    Widget? child,
  }) : super(key: key, child: child);

  factory StreamsSelector0.value({
    Key? key,
    required Stream<T> stream,
    required ValueWidgetBuilder<T> builder,
    Widget? child,
  }) {
    return StreamsSelector0(
      key: key,
      selector: (context) => stream,
      builder: builder,
      child: child,
    );
  }

  /// A function that obtains some [InheritedWidget] and map their content into
  /// a new object with only a limited number of properties.
  ///
  /// Must not be `null`
  final Stream<T> Function(BuildContext) selector;

  /// A function that builds a widget tree from `child` and the last result of
  /// [selector].
  ///
  /// [builder] will be called again whenever the its parent widget asks for an
  /// update
  ///
  /// Must not be `null`.
  final ValueWidgetBuilder<T> builder;

  @override
  _StreamsSelector0State<T> createState() => _StreamsSelector0State<T>();
}

class _StreamsSelector0State<T> extends SingleChildState<StreamsSelector0<T>> {
  T? value;
  Widget? cache;
  Widget? oldWidget;
  bool isInitialEventSkipped = false;
  Stream<T>? stream;

  @override
  void initState() {
    super.initState();

    // Get a stream from selector
    stream = widget.selector(context);
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) throw snapshot.error!;

        // Ignore a null event when create a stream
        if (!isInitialEventSkipped) {
          isInitialEventSkipped = true;
          return SizedBox.shrink();
        }

        final selected = snapshot.data;
        var shouldInvalidateCache = oldWidget != widget ||
            !const DeepCollectionEquality().equals(value, selected);
        if (shouldInvalidateCache) {
          value = selected;
          oldWidget = widget;
          cache = widget.builder(
            context,
            selected as T,
            child,
          );
        }
        return cache!;
      },
    );
  }
}

/// An equivalent to [Consumer] that can filter updates by selecting a limited
/// amount of values.
///
/// [StreamsSelector] will obtain a value using [StreamProvider.of], then pass that value
/// to `selector`. That `selector` callback is then tasked to return an object
/// that contains only the information needed for `builder` to complete.
class StreamsSelector<P, T> extends StreamsSelector0<T> {
  StreamsSelector({
    Key? key,
    required ValueWidgetBuilder<T> builder,
    required Stream<T> Function(BuildContext, P) selector,
    Widget? child,
  }) : super(
          key: key,
          builder: builder,
          selector: (context) => selector(context, StreamsProvider.of(context)),
          child: child,
        );
}

class StreamsSelector2<A, B, S> extends StreamsSelector0<S> {
  StreamsSelector2({
    Key? key,
    required ValueWidgetBuilder<S> builder,
    required Stream<S> Function(BuildContext, A, B) selector,
    Widget? child,
  }) : super(
          key: key,
          builder: builder,
          selector: (context) => selector(
            context,
            StreamsProvider.of(context),
            StreamsProvider.of(context),
          ),
          child: child,
        );
}
