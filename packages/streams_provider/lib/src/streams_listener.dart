import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/single_child_widget.dart';
import 'streams_listenable.dart';
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
class StreamsListener0<T> extends SingleChildStatefulWidget {
  const StreamsListener0({
    Key? key,
    this.selector,
    this.listener,
    this.listenable,
    this.child,
  })  : assert(listenable != null || (listener != null && selector != null)),
        super(key: key, child: child);

  //
  final Widget? child;

  /// A function that obtains some [InheritedWidget] and map their content into
  /// a new object with only a limited number of properties.
  ///
  /// Must not be `null` if [listenable] is `null`
  Stream<T> Function(BuildContext) get _selector =>
      selector ?? listenable!.selector;
  final Stream<T> Function(BuildContext)? selector;

  /// A function that will be called if [selector] emits a signal.
  ///
  /// Must not be `null`, if [listenable] is `null`
  StreamsWidgetListener<T> get _listener => listener ?? listenable!.handler;
  final StreamsWidgetListener<T>? listener;

  /// A class that will be called [StreamsListenable.handler] if [selector] emits a signal.
  ///
  /// Must not be `null`, if [listener] or [selector] is `null`.
  final StreamsListenable0<T>? listenable;

  @override
  SingleChildState<StreamsListener0<T>> createState() =>
      _StreamsListener0State<T>();
}

class _StreamsListener0State<T> extends SingleChildState<StreamsListener0<T>> {
  StreamSubscription? _subscription;
  @override
  void initState() {
    super.initState();

    final selected = widget._selector(context);

    _subscription?.cancel();
    _subscription = selected.listen((data) {
      widget._listener(context, data);
    });
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) => child!;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class StreamsListener<P extends StreamsProvidable, T>
    extends StreamsListener0<T> {
  StreamsListener({
    Key? key,
    P? provider,
    Stream<T> Function(BuildContext, P)? selector,
    StreamsWidgetListener<T>? listener,
    StreamsListenable<P, T>? listenable,
    Widget? child,
  })  : assert(listenable != null || (listener != null && selector != null)),
        super(
          key: key,
          child: child,
          selector: (context) {
            final p = provider ?? StreamsProvider.of<P>(context);

            if (selector != null) return selector(context, p);

            return listenable!.selector(context, p);
          },
          listener: listener ??
              (context, data) => listenable!.handler(
                    context,
                    provider ?? StreamsProvider.of(context),
                    data,
                  ),
        );
}

class StreamsListener2<P1 extends StreamsProvidable,
    P2 extends StreamsProvidable, T> extends StreamsListener0<T> {
  StreamsListener2({
    Key? key,
    P1? provider1,
    P2? provider2,
    Stream<T> Function(BuildContext, P1, P2)? selector,
    StreamsWidgetListener<T>? listener,
    StreamsListenable2<P1, P2, T>? listenable,
    Widget? child,
  })  : assert(listenable != null || (listener != null && selector != null)),
        super(
          key: key,
          child: child,
          selector: (context) {
            final p1 = provider1 ?? StreamsProvider.of<P1>(context);
            final p2 = provider2 ?? StreamsProvider.of<P2>(context);

            if (selector != null) return selector(context, p1, p2);

            return listenable!.selector(context, p1, p2);
          },
          listener: listener ??
              (context, data) => listenable!.handler(
                    context,
                    provider1 ?? StreamsProvider.of(context),
                    provider2 ?? StreamsProvider.of(context),
                    data,
                  ),
        );
}
