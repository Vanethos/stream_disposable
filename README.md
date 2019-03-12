[![Build Status](https://travis-ci.com/Vanethos/stream_disposable.svg?token=xwLpqqTE7aAFrSqs6UQm&branch=master)](https://travis-ci.com/Vanethos/stream_disposable)

# Stream Disposable

Package to help disposing Streams and Sinks.

## Simple Usage

Instantiate a disposable with
 
 ```dart
 var disposable = StreamDisposable()
 ```
Add StreamSubscriptions or Sinks to it by calling `add`
 
   ```dart
   var streamToDispose = Stream.fromIterable([1, 2, 3]);
   disposable.add(streamToDispose.listen(print))
   ```
   
In the Stateful's Widget `dispose` method or equivalent, we can call
 
 ```dart
 disposable.dispose(className: this.runtimeType.toString())
 ```
 
To safely dispose every subscription.

## Available Methods

- `void add`
Adds a [Sink](https://api.dartlang.org/stable/2.2.0/dart-core/Sink-class.html) or a [StreamSusbcription](https://api.dartlang.org/stable/2.2.0/dart-async/StreamSubscription-class.html) to the disposable. Throws an `Error` if another type of object is added or if the disposable has already been disposed.

- `Future<void> didDispose`
`Future` that completes when the `StreamDisposable` is disposed.

- `bool isDisposed`
Boolean value to check if the disposable has been disposed.

- `Future<void> dispose`
Dispose the current [Sink](https://api.dartlang.org/stable/2.2.0/dart-core/Sink-class.html) and [StreamSusbcription](https://api.dartlang.org/stable/2.2.0/dart-async/StreamSubscription-class.html) that were addded to this instance. Throws an error if a `dispose` action is in process or if the disposable has been disposed already.
