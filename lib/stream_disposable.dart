library stream_disposable;

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Helper Class that holds and disposes subscriptions
///
/// We can instantiate this class by calling
///    `var disposable = StreamDisposable()`
///
/// Then, we can simply add StreamSubscriptions to it by calling `add`
///
///   ```
///     var streamToDispose = Stream.fromIterable([1, 2, 3]);
///     disposable.add(streamToDispose.listen(print))
///   ```
///
/// Finally, in the Stateful's Widget `dispose´ method or equivalent, we can call
///
///  `disposable.dispose()`
///
/// To safely dispose every subscription
///
/// We can also add a class name to `dispose` so that it logs which class was disposed
///
///   `disposable.dispose(className: this.runtimeType.toString())`
///   // prints: "Disposing MyHomePage"
class StreamDisposable {

  StreamDisposable();

  List<StreamSubscription> _subscriptions = List();

  void add(StreamSubscription subscription) {
    if (subscription == null) {
      return;
    }
    _subscriptions.add(subscription);
  }

  void dispose({String className = ""}) {
    debugPrint("Disposing $className");
    if (_subscriptions.isNotEmpty) {
      _subscriptions.forEach((sub) => sub?.cancel());
    }
  }
}