import 'package:flutter/material.dart';
import 'package:one_handed_cursor/custom_widgets/button.dart';
import 'package:provider/provider.dart';

import 'custom_widgets/cursor.dart';
import 'custom_widgets/touchpad.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CursorNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ButtonNotfiier(),
        ),
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
  final GlobalKey buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Custom Cursor'),
          ),
          body: Stack(children: [
            Button(
              key: buttonKey,
              x: 16.0,
              y: 16.0,
            ),
            const Cursor(),
            Touchpad(
              onUpdatePosition: (double x, double y) {
                Provider.of<CursorNotifier>(context, listen: false)
                    .updatePosition(x, y);
              },
              onTap: () {},
            ),
          ])),
    );
  }
}
