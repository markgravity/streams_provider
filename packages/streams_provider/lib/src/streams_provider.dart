import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'streams_providable.dart';

class StreamsProvider<T extends StreamsProvidable>
    extends SingleChildStatelessWidget {
  StreamsProvider({
    Key key,
    @required Create<T> create,
    Widget child,
    bool lazy,
  }) : this._(
          key: key,
          create: create,
          dispose: (_, provider) => provider?.dispose(),
          child: child,
          lazy: lazy,
        );

  /// Takes a [provider] and a [child] which will have access to the [provider] via
  /// `StreamsProvider.of(context)`.
  /// When `StreamsProvider.value` is used, the [provider] will not be automatically
  /// closed.
  /// As a result, `StreamsProvider.value` should mainly be used for providing
  /// existing [provider]s to new routes.
  ///
  /// A new [provider] should not be created in `StreamsProvider.value`.
  /// [provider]s should always be created using the default constructor within
  /// [create].
  ///
  /// ```dart
  /// StreamsProvider.value(
  ///   value: StreamsProvider.of<ProviderA>(context),
  ///   child: ScreenA(),
  /// );
  StreamsProvider.value({
    Key key,
    @required T value,
    Widget child,
  }) : this._(
          key: key,
          create: (_) => value,
          child: child,
        );

  /// Internal constructor responsible for creating the [StreamsProvider].
  /// Used by the [StreamsProvider] default and value constructors.
  StreamsProvider._({
    Key key,
    @required Create<T> create,
    Dispose<T> dispose,
    this.child,
    this.lazy,
  })  : _create = create,
        _dispose = dispose,
        super(key: key, child: child);

  /// [child] and its descendants which will have access to the [bloc].
  final Widget child;

  /// Whether or not the [Provider] being provided should be lazily created.
  /// Defaults to `true`.
  final bool lazy;

  final Dispose<T> _dispose;

  final Create<T> _create;

  @override
  Widget buildWithChild(BuildContext context, Widget child) {
    return InheritedProvider<T>(
      create: _create,
      dispose: _dispose,
      child: child,
      lazy: lazy,
    );
  }

  /// Method that allows widgets to access a [provider] instance as long as their
  /// `BuildContext` contains a [StreamsProvider] instance.
  ///
  /// If we want to access an instance of `BlocA` which was provided higher up
  /// in the widget tree we can do so via:
  ///
  /// ```dart
  /// StreamsProvider.of<Provider>(context)
  /// ```
  static T of<T>(BuildContext context) {
    try {
      return Provider.of<T>(context, listen: false);
    } on ProviderNotFoundException catch (_) {
      throw FlutterError(
        """
        StreamsProvider.of() called with a context that does not contain a provider of type $T.
        No ancestor could be found starting from the context that was passed to StreamsProvider.of<$T>().
        This can happen if the context you used comes from a widget above the StreamsProvider.
        The context used was: $context
        """,
      );
    }
  }
}

/// Extends the `BuildContext` class with the ability
/// to perform a lookup based on a `StreamProvidable` type.
extension StreamsProviderExtension on BuildContext {
  /// Performs a lookup using the `BuildContext` to obtain
  /// the nearest ancestor `StreamProvidable` of type [P].
  ///
  /// Calling this method is equivalent to calling:
  ///
  /// ```dart
  /// StreamsProvider.of<P>(context)
  /// ```
  P provider<P extends StreamsProvidable>() => StreamsProvider.of<P>(this);
}
