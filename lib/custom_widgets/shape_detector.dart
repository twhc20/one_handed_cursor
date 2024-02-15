import 'package:flutter/material.dart';
import 'package:one_handed_cursor/pages/gesture_detector_page.dart';
import 'package:one_handed_cursor/unistroke_recogniser/dialogs.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter({required this.pointsList});

  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List<Offset>.empty(growable: true);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      canvas.drawLine(
          pointsList[i].points, pointsList[i + 1].points, pointsList[i].paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({required this.points, required this.paint});
}

// ignore: must_be_immutable
class ShapeDetector extends StatefulWidget {
  final Color selectedColor;
  final double strokeWidth;
  final List<DrawingPoints> points;
  final double opacity;
  final StrokeCap strokeCap;
  
  const ShapeDetector(
      {super.key,
      required this.selectedColor,
      required this.strokeWidth,
      required this.points,
      required this.opacity,
      required this.strokeCap});

  @override
  State<ShapeDetector> createState() => _ShapeDetectorState();
}

class _ShapeDetectorState extends State<ShapeDetector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.greenAccent),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: () async {
                            final result = await Dialogs.inputDialog(
                                context, "".toString());

                            recognizer.addGesture(result, pointsToRecognize);
                          }),
                      IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              widget.points.clear();
                            });
                          }),
                    ],
                  ),
                ],
              ),
            )),
      ),
      body: Builder(
        builder: (context) => GestureDetector(
          onPanStart: (details) {
            setState(() {
              RenderBox? renderBox = context.findRenderObject() as RenderBox;
              pointsToRecognize = List<Point>.empty(growable: true);
              pointsToRecognize.add(Point(
                  renderBox.globalToLocal(details.globalPosition).dx,
                  renderBox.globalToLocal(details.globalPosition).dy));
              widget.points.clear();
              widget.points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = widget.strokeCap
                    ..isAntiAlias = true
                    ..color = widget.selectedColor
                    ..strokeWidth = widget.strokeWidth));
            });
          },
          onPanUpdate: (details) {
            setState(() {
              RenderBox? renderBox = context.findRenderObject() as RenderBox;
              pointsToRecognize.add(Point(
                  renderBox.globalToLocal(details.globalPosition).dx,
                  renderBox.globalToLocal(details.globalPosition).dy));
              widget.points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = widget.strokeCap
                    ..isAntiAlias = true
                    ..color = widget.selectedColor
                    ..strokeWidth = widget.strokeWidth));
            });
          },
          onPanEnd: (details) async {
            setState(() {
              widget.points.add(DrawingPoints(
                  points: Offset.infinite,
                  paint: Paint()
                    ..strokeCap = widget.strokeCap
                    ..isAntiAlias = true
                    ..color = widget.selectedColor
                    ..strokeWidth = widget.strokeWidth));
            });
            Result result =
                await recognizer.recognize(pointsToRecognize, false);
            final snackBar = SnackBar(
                content: Text(
                    "Result : name : ${result.name}, score : ${result.score}, ms : ${result.ms}"));
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawingPainter(
              pointsList: widget.points,
            ),
          ),
        ),
      ),
    );
  }
}
