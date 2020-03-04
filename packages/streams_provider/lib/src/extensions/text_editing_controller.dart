import 'package:flutter/widgets.dart';

import '../mutable_value_stream.dart';

extension TextEditingControllerWithStreams on TextEditingController {
  /// A [MutableValueStream] that will
  /// update [text] when a new event is emitted,
  /// also emits a new event when [text] changes
  MutableValueStream<String> textStream() {
    final stream = MutableValueStream<String>(this.text);
    bool isLock = false;

    // Set a new text to controller
    // when stream is emitted
    stream.listen((text) {
      print(this);
      if (isLock) return;
      isLock = true;
      this?.text = text;
      isLock = false;
    });

    // Set value back to stream
    // when the text got changed in controller
    this.addListener(() async {
      if (isLock) return;
      isLock = true;
      stream.value = this.text;
      await Future.delayed(Duration(microseconds: 1));
      isLock = false;
    });
    return stream;
  }

  /// A [MutableValueStream] that will
  /// update [selection] when a new event is emitted,
  /// also emits a new event when [selection] changes
  MutableValueStream<TextSelection> selectionStream() {
    final stream = MutableValueStream<TextSelection>(this.selection);
    bool isLock = false;

    // Set a new text to controller
    // when stream is emitted
    stream.listen((data) {
      if (isLock) return;
      isLock = true;
      this?.selection = data;
      isLock = false;
    });

    // Set value back to stream
    // when the text got changed in controller
    this.addListener(() async {
      if (isLock) return;
      isLock = true;
      stream.value = this.selection;
      await Future.delayed(Duration(microseconds: 1));
      isLock = false;
    });
    return stream;
  }

  /// A [MutableValueStream] that will
  /// update [value] when a new event is emitted,
  /// also emits a new event when [value] changes
  MutableValueStream<TextEditingValue> valueStream() {
    final stream = MutableValueStream<TextEditingValue>(this.value);
    bool isLock = false;

    // Set a new text to controller
    // when stream is emitted
    stream.listen((data) {
      if (isLock) return;
      isLock = true;
      this?.value = data;
      isLock = false;
    });

    // Set value back to stream
    // when the text got changed in controller
    this.addListener(() async {
      if (isLock) return;
      isLock = true;
      stream.value = this.value;
      await Future.delayed(Duration(microseconds: 1));
      isLock = false;
    });
    return stream;
  }
}
