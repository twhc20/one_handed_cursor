import 'package:flutter/material.dart';
import 'package:one_handed_cursor/pages/basic_cursor_page.dart';
import 'package:one_handed_cursor/pages/gesture_detector_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Custom Cursor'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            Positioned(
              left: 16.0,
              top: 10.0,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BasicCursorPage()));
                  },
                  child: const Text("Basic Cursor and Touchpad")),
            ),
            Positioned(
              left: 16.0,
              top: 100.0,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GestureDetectorPage()));
                  },
                  child: const Text("Gesture Detector")),
            ),
          ]),
        ));
  }
}
