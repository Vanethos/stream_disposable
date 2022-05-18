library stream_disposable;

import 'dart:async';

/// Helper Class that holds and disposes stream subscriptions, sinks and timers
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
class StreamDisposable {
  StreamDisposable();

  List<StreamSubscription> _streamsSubscriptions = [];
  List<Sink> _sinks = [];

  final Completer<Null> _didDispose = Completer<Null>();

  /// Checks if the Disposable has been disposed
  bool get isDisposed => _didDispose.isCompleted;
  bool _isDisposing = false;

  /// Future that completes when the StreamDisposable finishes disposing
  Future<void> get didDispose => _didDispose.future;

  /// Adds a Stream Subscription or Sink to be disposed in the future
  ///
  /// This method will throw an Exception if the value is null or if the
  /// disposable has been disposed
  ///
  /// This method will throw an Error if the object is not of the correct type
  void add(dynamic subscription) {
    if (subscription == null) {
      throw Exception("Null value added to disposable");
    }
    if (isDisposed) {
      throw Exception("Already disposed");
    }
    if (subscription is StreamSubscription) {
      _streamsSubscriptions.add(subscription);
      return;
    }
    if (subscription is Sink) {
      _sinks.add(subscription);
      return;
    }
    // if the type is not supported, we throw a TypeNotSupported Error
    throw new TypeNotSupported(type: subscription.runtimeType.toString());
  }

  /// Dipose Resources
  ///
  /// This method will dispose all the Stream Subscriptions and Sinks that were
  /// added to the StreamDisposable.
  ///
  /// If there is already a `dispose` action in progress, this method will
  /// throw an exception
  ///
  /// In the same way, if the disposable is already disposed, this method will
  /// throw an exception
  ///
  /// className: Class name to appear in the debugPrint statement
  Future<void> dispose({String className = ""}) async {
    if (_isDisposing) {
      throw Exception("Already disposing");
    }
    if (isDisposed) {
      throw Exception("Already disposed");
    }
    _isDisposing = true;
    print("Disposing $className");
    Future<void>? subscriptionFuture;
    Future<void>? sinkFuture;
    if (_streamsSubscriptions.isNotEmpty) {
      subscriptionFuture =
          Future.wait(_streamsSubscriptions.map((sub) => sub.cancel()));
    }
    if (_sinks.isNotEmpty) {
      sinkFuture = Future.sync(() => _sinks.map((sink) => sink.close()));
    }
    return Future.wait([
      subscriptionFuture ?? Future.value(null),
      sinkFuture ?? Future.value(null),
    ]).then((_) {
      _didDispose.complete();
      _isDisposing = false;
    });
  }
}

/// Custom Rrror to show that the added object is not of the correct type
class TypeNotSupported extends Error {
  String type;

  TypeNotSupported({this.type = "N/A"});

  @override
  String toString() =>
      "Type is not supported, please provide an object of type Sink or StreamSubscription but is of type $type";
}
