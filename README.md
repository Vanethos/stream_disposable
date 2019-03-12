[![Build Status](https://travis-ci.com/Vanethos/stream_disposable.svg?token=xwLpqqTE7aAFrSqs6UQm&branch=master)](https://travis-ci.com/Vanethos/stream_disposable)

# Stream Disposable

Package to help disposing Streams and Sinks.

## Usage

Instantiate a disposable with
 
    var disposable = StreamDisposable()
    
Add StreamSubscriptions or Sinks to it by calling `add`
 
   ```
   var streamToDispose = Stream.fromIterable([1, 2, 3]);
   disposable.add(streamToDispose.listen(print))
   ```
   
In the Stateful's Widget `dispose` method or equivalent, we can call
 
  `disposable.dispose(className: this.runtimeType.toString())`
  
To safely dispose every subscription.
