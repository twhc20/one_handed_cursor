import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CursorNotifier extends ChangeNotifier {
  double positionX = 0;
  double positionY = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  double radius;

  CursorNotifier({this.radius = 10.0});

  void updateScreenSize(double width, double height) {
    screenWidth = width;
    screenHeight = height;
  }

  void updatePosition(double x, double y) {
    positionX = x.clamp(0, screenWidth - radius * 2);
    positionY = y.clamp(0, screenHeight - radius * 2);
    notifyListeners();
  }
}

class Cursor extends StatelessWidget {
  final double radius;

  const Cursor({Key? key, this.radius = 10.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cursorNotifier = Provider.of<CursorNotifier>(context);
    final screenSize = MediaQuery.of(context).size;
    cursorNotifier.updateScreenSize(screenSize.width, screenSize.height);

    return Positioned(
      left: cursorNotifier.positionX,
      top: cursorNotifier.positionY,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
      ),
    );
  }
}
