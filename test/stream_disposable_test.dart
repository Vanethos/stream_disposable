import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_disposable/stream_disposable.dart';

void main() {
  test('Disposing a disposable with no data throws no error', () {
    var disposable = StreamDisposable();

    expect(disposable.dispose(), completes);
  });

  test('Adding correct types does not throw an error', () async {
    var disposable = StreamDisposable();

    var streamController = StreamController<int>();
    var sink = streamController.sink;
    var stream = streamController.stream;

    expect(disposable.isDisposed, false);

    disposable.add(sink);
    disposable.add(stream.listen(null));

    expect(disposable.dispose(), completes);
    expect(disposable.didDispose, completes);
    await Future.delayed(Duration(seconds: 1));
    expect(disposable.isDisposed, true);
  });

  test('Disposing with a subscription that has been disposed previously',
      () async {
    var disposable = StreamDisposable();

    var streamController = StreamController<int>();
    var stream = streamController.stream;
    var subscription = stream.listen(null);

    disposable.add(subscription);

    await subscription.cancel();

    expect(disposable.dispose(), completes);
    expect(disposable.didDispose, completes);
    await Future.delayed(Duration(seconds: 1));
    expect(disposable.isDisposed, true);
  });

  test('Disposing with a sink that has been disposed previously', () async {
    var disposable = StreamDisposable();

    var streamController = StreamController<int>();
    var sink = streamController.sink;

    disposable.add(sink);

    sink.close();

    expect(disposable.dispose(), completes);
    expect(disposable.didDispose, completes);
    await Future.delayed(Duration(seconds: 1));
    expect(disposable.isDisposed, true);
  });

  test('Wrong type throws an error', () {
    var disposable = StreamDisposable();

    expect(
        () => disposable.add("test"), throwsA(TypeMatcher<TypeNotSupported>()));
  });

  test("Disposing two times throws an exception - dispose", () {
    var disposable = StreamDisposable();

    disposable.dispose();
    expect(disposable.dispose(), throwsException);
  });

  test("Disposing a disposed disposable throws an exception", () async {
    var disposable = StreamDisposable();

    disposable.dispose();
    await Future.delayed(Duration(seconds: 1));
    expect(disposable.dispose(), throwsException);
  });
}
