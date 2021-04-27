import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/single_child_widget.dart';

import 'streams_listenable.dart';
import 'streams_listener.dart';
import 'streams_providable.dart';
import 'streams_provider.dart';

class MultiStreamsListener0<P extends StreamsProvidable>
    extends SingleChildStatefulWidget {
  const MultiStreamsListener0({
    Key? key,
    this.provider,
    this.selectors,
    this.listeners,
    this.listenablies,
    this.child,
  })  : assert(
            listenablies != null || (listeners != null && selectors != null)),
        super(key: key, child: child);

  //
  final P? provider;
  final Widget? child;

  /// A function that obtains some [InheritedWidget] and map their content into
  /// a new object with only a limited number of properties.
  ///
  /// Must not be `null` if [listenable] is `null`
  List<Stream Function(BuildContext)> get _selectors =>
      selectors ??
      listenablies!.map((v) => v.selector)
          as List<Stream Function(BuildContext)>;
  final List<Stream Function(BuildContext)>? selectors;

  /// A function that will be called if [selector] emits a signal.
  ///
  /// Must not be `null`, if [listenable] is `null`
  List<StreamsWidgetListener> get _listeners =>
      listeners ??
      listenablies!.map((v) => v.handler) as List<StreamsWidgetListener>;
  final List<StreamsWidgetListener>? listeners;

  /// A class that will be called [StreamsListenable.handler] if [selector] emits a signal.
  ///
  /// Must not be `null`, if [listener] or [selector] is `null`.
  final List<StreamsListenable0>? listenablies;

  @override
  SingleChildState<MultiStreamsListener0> createState() =>
      _MultiStreamsListener0State();
}

class _MultiStreamsListener0State
    extends SingleChildState<MultiStreamsListener0> {
  List<StreamSubscription> _subscriptions = [];
  @override
  void initState() {
    super.initState();

    _cancelAllSubscriptions();
    for (int i = 0; i < widget._selectors.length; i++) {
      final selector = widget._selectors[i];
      final listener = widget._listeners[i];
      final selected = selector(context);

      final subscription = selected.listen((data) {
        listener(context, data);
      });
      _subscriptions.add(subscription);
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
      child ?? Container();

  void _cancelAllSubscriptions() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }

    _subscriptions = [];
  }

  @override
  void dispose() {
    _cancelAllSubscriptions();
    super.dispose();
  }
}

class MultiStreamsListener<P extends StreamsProvidable, T1, T2>
    extends MultiStreamsListener0 {
  MultiStreamsListener({
    Key? key,
    P? provider,
    Stream<T1> Function(BuildContext, P)? selector1,
    StreamsWidgetListener<T1>? listener1,
    StreamsListenable<P, T1>? listenable1,
    Stream<T2> Function(BuildContext, P)? selector2,
    StreamsWidgetListener<T2>? listener2,
    StreamsListenable<P, T2>? listenable2,
    Widget? child,
  })  : assert((listenable1 != null ||
                (listener1 != null && selector1 != null)) &&
            (listenable2 != null || (listener2 != null && selector2 != null))),
        super(
            key: key,
            child: child,
            selectors: [
              (context) {
                final p = provider ?? StreamsProvider.of<P>(context);

                if (selector1 != null) return selector1(context, p);

                return listenable1!.selector(context, p);
              },
              (context) {
                final p = provider ?? StreamsProvider.of<P>(context);

                if (selector2 != null) return selector2(context, p);

                return listenable2!.selector(context, p);
              }
            ],
            listeners: [
              listener1 ??
                  (context, data) => listenable1!.handler(
                        context,
                        provider ?? StreamsProvider.of(context),
                        data,
                      ),
              listener2 ??
                  (context, data) => listenable2!.handler(
                        context,
                        provider ?? StreamsProvider.of(context),
                        data,
                      ),
            ] as List<StreamsWidgetListener>);
}
