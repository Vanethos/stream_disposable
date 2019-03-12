import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';

import 'package:stream_disposable/stream_disposable.dart';

void main() {
  test('dispose using disposable', () async {
    var stream = Future.doWhile(() async {
      //await Future.delayed(Duration(milliseconds: 300));
      debugPrint("Listen ${DateTime.now()}");
      return true;
    }).asStream();

    var disposed = false;

    var disposable = StreamDisposable();

    disposable.add(stream.listen((_) async {
      if (disposed) {
        //wait for it to be disposed
        await Future.delayed(Duration(seconds: 1));
        expect(actual, matcher)
      }
    }));


    //idea: add to sink
    await disposable.dispose();

    disposed = true;

    debugPrint("After disposing ${DateTime.now()}");


    //expect(subscription.isPaused, true);
  });

  test('dispose disposed subscription', () async {
    var stream = Future.doWhile(() async {
      //await Future.delayed(Duration(milliseconds: 300));
      debugPrint("Listen ${DateTime.now()}");
      return true;
    }).asStream();

    var disposed = false;

    var disposable = StreamDisposable();

    var subscription = stream.listen(null);

    disposable.add(subscription);

    await subscription.cancel();

    await disposable.dispose();

    await subscription.cancel();

    debugPrint("After disposing ${DateTime.now()}");


    //expect(subscription.isPaused, true);
  });
}
