import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cursor/cursor.dart';
import 'touchpad/touchpad.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CursorNotifier(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int counter = 0;
  final buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Custom Cursor'),
          ),
          body: Stack(children: [
            Positioned(
              bottom: 300,
              right: 100,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {},
                child: ElevatedButton(
                  onPressed: null, // Disable the button's own onPressed event
                  child: Text('Counter: $counter'),
                ),
              ),
            ),
            const Cursor(),
            Touchpad(
              onUpdatePosition: (double x, double y) {
                Provider.of<CursorNotifier>(context, listen: false)
                    .updatePosition(x, y);
              },
            ),
          ])),
    );
  }
}
