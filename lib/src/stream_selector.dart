import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart' hide StreamProvider;
import 'package:provider/single_child_widget.dart';
import 'package:stream_provider/stream_provider.dart';

/// A base class for custom [StreamSelector].
///
/// It works with any [InheritedWidget]. Variants like [StreamSelector] and
/// [StreamSelector6] are just syntax sugar to use [StreamSelector0] with [StreamProvider.of].
class StreamSelector0<T> extends SingleChildStatefulWidget {
  /// Both `builder` and `selector` must not be `null`.
  StreamSelector0({
    Key key,
    @required this.selector,
    @required this.builder,
    Widget child,
  })  : assert(builder != null),
        assert(selector != null),
        super(key: key, child: child);

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
  _StreamSelector0State<T> createState() => _StreamSelector0State<T>();
}

class _StreamSelector0State<T> extends SingleChildState<StreamSelector0<T>> {
  Widget cache;
  Widget oldWidget;

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    final stream = widget.selector(context);
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final selected = snapshot.data;
        var shouldInvalidateCache = oldWidget != widget;
        if (shouldInvalidateCache) {
          cache = widget.builder(
            context,
            selected,
            child,
          );
        }
        return cache;
      },
    );
  }
}


/// An equivalent to [Consumer] that can filter updates by selecting a limited
/// amount of values.
///
/// [StreamSelector] will obtain a value using [StreamProvider.of], then pass that value
/// to `selector`. That `selector` callback is then tasked to return an object
/// that contains only the information needed for `builder` to complete.
class StreamSelector<A, S> extends StreamSelector0<S> {
  StreamSelector({
             Key key,
             @required ValueWidgetBuilder<S> builder,
             @required Stream<S> Function(BuildContext, A) selector,
             Widget child,
           })  : assert(selector != null),
      super(
      key: key,
      builder: builder,
      selector: (context) => selector(context, StreamProvider.of(context)),
      child: child,
    );
}

class StreamSelector2<A, B, S> extends StreamSelector0<S> {

  StreamSelector2({
              Key key,
              @required ValueWidgetBuilder<S> builder,
              @required Stream<S> Function(BuildContext, A, B) selector,
              Widget child,
            })  : assert(selector != null),
      super(
      key: key,
      builder: builder,
      selector: (context) => selector(
        context,
        StreamProvider.of(context),
        StreamProvider.of(context),
      ),
      child: child,
    );
}
