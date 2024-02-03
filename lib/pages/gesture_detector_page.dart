import 'dart:io';

import 'package:flutter/material.dart';
import 'package:one_handed_cursor/unistroke_recogniser/dialogs.dart';
import 'package:one_handed_cursor/unistroke_recogniser/gestures_templates.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';

var recognizer = DollarRecognizer.withGestures(getTemplates());
late List<Point> pointsToRecognize;

class Draw extends StatefulWidget {
  const Draw({super.key});

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List<DrawingPoints>.empty(growable: true);
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;

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

                            // Convert points to string
                            String pointsString = pointsToRecognize
                                .map((point) =>
                                    'new Point(${point.x}, ${point.y}),')
                                .join('\n');

                            // Create the string to write to the file
                            String fileContent =
                                'unistrokes.add(new Unistroke("$result", [\n$pointsString\n]));';

                            // Write to the file
                            final file = File(
                                r"C:\Users\Timothy Chan\Documents\Flutter Projects\One_Handed_Cursor\one_handed_cursor\lib\unistroke_recogniser\data.txt");
                            await file.writeAsString(fileContent,
                                mode: FileMode.append);
                          }),
                      IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              points.clear();
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
              points.clear();
              points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor
                    ..strokeWidth = strokeWidth));
            });
          },
          onPanUpdate: (details) {
            setState(() {
              RenderBox? renderBox = context.findRenderObject() as RenderBox;
              pointsToRecognize.add(Point(
                  renderBox.globalToLocal(details.globalPosition).dx,
                  renderBox.globalToLocal(details.globalPosition).dy));
              points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor
                    ..strokeWidth = strokeWidth));
            });
          },
          onPanEnd: (details) async {
            setState(() {
              points.add(DrawingPoints(
                  points: Offset.infinite,
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor
                    ..strokeWidth = strokeWidth));
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
              pointsList: points,
            ),
          ),
        ),
      ),
    );
  }
}

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
