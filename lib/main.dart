import 'dart:isolate';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHome(),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Image.asset('assets/gifs/bouncing-ball.gif'),
            // Blocking  UI
            ElevatedButton(
              onPressed: () async {
                var total = await complexTask();
                print('Result 1: $total');
              },
              child: const Text('Task 1'),
            ),
            // Isolate
            ElevatedButton(
              onPressed: () async {
                // spwan means creating a new instance.
                final receivePort = ReceivePort();
                await Isolate.spawn(complexTask2, receivePort.sendPort);
                receivePort.listen((total) {
                  print('Result 2: $total');
                });
              },
              child: const Text('Task 2'),
            ),
            ElevatedButton(
              onPressed: () {
                //
              },
              child: const Text('Task 3'),
            ),
          ],
        ),
      )),
    );
  }

  Future<double> complexTask() async {
    var total = 0.0;
    for (int i = 0; i < 100000000; ++i) {
      total += i;
    }
    return total;
  }
}

// Function should be outside of the class

complexTask2(SendPort sendPort) {
  var total = 0.0;
  for (int i = 0; i < 100000000; ++i) {
    total += i;
  }
  sendPort.send(total);
}
