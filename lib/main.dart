import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class CustomCursorWidget extends StatefulWidget {
  @override
  _CustomCursorWidgetState createState() => _CustomCursorWidgetState();
}

class _CustomCursorWidgetState extends State<CustomCursorWidget> {
  double cursorX = 0.0;
  double cursorY = 0.0;

  double boxWidth = 100.0;
  double boxHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        double newX = cursorX + details.delta.dx;
        double newY = cursorY + details.delta.dy;

        // Ensure cursor stays within the rectangular box
        if (newX >= 0 && newX <= MediaQuery.of(context).size.width - boxWidth) {
          cursorX = newX;
        }

        if (newY >= 0 && newY <= MediaQuery.of(context).size.height - boxHeight) {
          cursorY = newY;
        }

        setState(() {});
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Your background content goes here

            // Rectangular box
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: boxWidth,
                height: boxHeight,
                color: Colors.red,
              ),
            ),

            // Custom cursor
            Positioned(
              left: cursorX - 25,
              top: cursorY - 25,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Cursor'),
        ),
        body: CustomCursorWidget(),
      ),
    );
  }
}
