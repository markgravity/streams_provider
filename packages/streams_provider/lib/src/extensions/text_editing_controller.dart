import 'package:flutter/widgets.dart';
import 'package:streams_provider/streams_provider.dart';

extension TextEditingControllerWithStreams on TextEditingController {
  /// A [BehaviorSubject] that will
  /// update [text] when a new event is emitted,
  /// also emits a new event when [text] changes
  BehaviorSubject<String> textStream() {
    final stream = BehaviorSubject<String>.seeded(this.text);
    bool isLock = false;

    // Set a new text to controller
    // when stream is emitted
    stream.listen((text) {
      if (isLock) return;
      isLock = true;
      this.text = text;
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

  /// A [BehaviorSubject] that will
  /// update [selection] when a new event is emitted,
  /// also emits a new event when [selection] changes
  BehaviorSubject<TextSelection> selectionStream() {
    final stream = BehaviorSubject<TextSelection>.seeded(this.selection);
    bool isLock = false;

    // Set a new text to controller
    // when stream is emitted
    stream.listen((data) {
      if (isLock) return;
      isLock = true;
      this.selection = data;
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

  /// A [BehaviorSubject] that will
  /// update [value] when a new event is emitted,
  /// also emits a new event when [value] changes
  BehaviorSubject<TextEditingValue> valueStream() {
    final stream = BehaviorSubject<TextEditingValue>.seeded(this.value);
    bool isLock = false;

    // Set a new text to controller
    // when stream is emitted
    stream.listen((data) {
      if (isLock) return;
      isLock = true;
      this.value = data;
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
