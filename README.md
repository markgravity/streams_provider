# Stream Provider

![Coverage](https://raw.githubusercontent.com/markgravity/stream_provider/master/coverage_badge.svg?sanitize=true) [![GitHub issues](https://img.shields.io/github/issues/markgravity/stream_provider)](https://github.com/markgravity/stream_provider/issues) [![GitHub stars](https://img.shields.io/github/stars/markgravity/stream_provider)](https://github.com/markgravity/stream_provider/stargazers) [![GitHub license](https://img.shields.io/github/license/markgravity/object_mapper)](https://github.com/markgravity/stream_provider/blob/master/LICENSE)

------

A package makes it easy for you to use stream with Provider.

**Pros**

* Doesn't need call  `notifyListeners` everytime, everywhere.

- Able to use power of `stream` and RxDart, when you have to deal with complex tasks

**Cons**

* Need to `close()` every Stream that you declare into Provider inside  `dispose()`



## Usage

### Exposing a value

#### Exposing a new object instance

Create a new object inside `create`.

```dart
StreamProvider(
  create: (_) => new MyModel(),
  child: ...

```



#### Reusing an existing object instance:

If you already have an object instance and want to expose it,
you should use the `.value` constructor of a provider.

Failing to do so may call the `dispose` method of your object when it is still in use.

Use StreamProvider.value` to provide an existing
`Provider.

```dart
MyProvider variable;

StreamProvider.value(
  value: variable,
  child: ...
)
```



### Reading a value

The easiest way to read a value is by using the static method

StreamProvider.of<T>(BuildContext context)`.

or

`context.provider<T>()`

This method will look up in the widget tree starting from the widget associated
with the `BuildContext` passed and it will return the nearest variable of type
`T` found (or throw if nothing is found)