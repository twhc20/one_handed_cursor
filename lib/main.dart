import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cursor/cursor.dart';
import 'touchpad/touchpad.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CursorNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Custom Cursor'),
          ),
          body: Stack(children: [
            Cursor(),
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
