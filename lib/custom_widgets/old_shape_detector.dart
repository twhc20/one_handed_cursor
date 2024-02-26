import 'package:flutter/material.dart';
import 'package:one_handed_cursor/custom_widgets/shape_detector.dart';
import 'package:one_handed_cursor/pages/gesture_detector_page.dart';
import 'package:one_handed_cursor/unistroke_recogniser/dialogs.dart';
import 'package:one_handed_cursor/unistroke_recogniser/unistroke_recogniser.dart';

// ignore: must_be_immutable
class OldShapeDetector extends StatefulWidget {
  final Color selectedColor;
  final double strokeWidth;
  final List<DrawingPoints> points;
  final double opacity;
  final StrokeCap strokeCap;

  const OldShapeDetector(
      {super.key,
      required this.selectedColor,
      required this.strokeWidth,
      required this.points,
      required this.opacity,
      required this.strokeCap});

  @override
  State<OldShapeDetector> createState() => _OldShapeDetectorState();
}

class _OldShapeDetectorState extends State<OldShapeDetector> {
  bool canDraw = true;

  void setCanDraw(bool value) {
    setState(() {
      canDraw = value;
    });
  }

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
            if (!canDraw) {
              return;
            }
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
            if (!canDraw) {
              return;
            }
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
            if (!canDraw) {
              return;
            }
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
