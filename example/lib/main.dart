import 'dart:async';

import 'package:flutter/material.dart';

import 'package:stream_disposable/stream_disposable.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  var disposable = StreamDisposable();

  void _incrementCounter() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PageB()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Click on the button to go to the next page and stop counting:',
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    var controller = StreamController<int>();
    var sink = controller.sink;
    var stream = controller.stream;
    disposable.add(
      stream.listen((data) {
        setState(() {
          _counter = data;
        });
      })
    );

    disposable.add(sink);

    Timer.periodic(Duration(milliseconds: 500), (i) {
      try {
        sink.add(i.tick);
      } catch (e) {
        print("Closed sink");
        i.cancel();
      }
    });
  }

  /// When pushing, we will dispose of the stream
  @override
  void deactivate() {
    disposable.dispose(className: this.runtimeType.toString());
  }
}

class PageB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page B"),
      ),
      body: Container(
        color: Colors.amber,
      ),
    );
  }
}
