import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/single_child_widget.dart';
import 'streams_providable.dart';
import 'streams_provider.dart';

typedef StreamsWidgetListener<T> = void Function(BuildContext context, T data);

/// A Flutter Widget class which takes a [StreamsWidgetListener] and a selector.
///
/// It invokes the listener in response to signal emits in the selector stream
/// and should be used for functionality that needs to occur once per signal emit
/// such as navigation, showing a [SnackBar], showing a [Dialog], etc...
///
/// [listener] is only called once for each signal emit.
class StreamsListener<P extends StreamsProvidable, T> extends SingleChildStatefulWidget {
  const StreamsListener({
    Key key,
    @required this.selector,
    @required this.listener,
    this.child,
  }) : super(key: key, child: child);

  //
  final Widget child;

  /// A function that obtains some [InheritedWidget] and map their content into
  /// a new object with only a limited number of properties.
  ///
  /// Must not be `null`
  final Stream<T> Function(BuildContext, P) selector;

  /// A function that will be called if [selector] emits a signal.
  ///
  /// Must not be `null`.
  final StreamsWidgetListener<T> listener;

  @override
  SingleChildState<StreamsListener<P, T>> createState() => _StreamsListenerState<P, T>();
}

class _StreamsListenerState<P extends StreamsProvidable, T>
    extends SingleChildState<StreamsListener<P, T>> {
  @override
  void initState() {
    super.initState();

    final selected = widget.selector(context, StreamsProvider.of(context));
    selected.skip(1).listen((data) {
      widget.listener(context, data);
    });
  }

  @override
  Widget buildWithChild(BuildContext context, Widget child) => child;

  @override
  void dispose() {
    super.dispose();
  }
}
