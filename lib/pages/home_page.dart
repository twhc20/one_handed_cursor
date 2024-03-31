import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:one_handed_cursor/csv/csv.dart';
import 'package:one_handed_cursor/csv/file_storage.dart';
import 'package:one_handed_cursor/pages/basic_cursor_page.dart';
import 'package:one_handed_cursor/pages/basic_target_page.dart';
import 'package:one_handed_cursor/pages/basic_target_page_large.dart';
import 'package:one_handed_cursor/pages/continuous_target_page.dart';
import 'package:one_handed_cursor/pages/continuous_target_page_large.dart';
import 'package:one_handed_cursor/pages/generate_cursor_page.dart';
import 'package:one_handed_cursor/pages/gesture_detector_page.dart';
import 'package:one_handed_cursor/pages/left_big_1.5_page.dart';
import 'package:one_handed_cursor/pages/left_big_1_page.dart';
import 'package:one_handed_cursor/pages/left_big_1_page_continuous.dart';
import 'package:one_handed_cursor/pages/left_small_1.5_page.dart';
import 'package:one_handed_cursor/pages/left_small_1.5_page_continuous.dart';
import 'package:one_handed_cursor/pages/left_small_1_page.dart';
import 'package:one_handed_cursor/pages/left_small_1_page_continuous.dart';
import 'package:one_handed_cursor/pages/right_big_1.5_page.dart';
import 'package:one_handed_cursor/pages/right_big_1.5_page_continuous.dart';
import 'package:one_handed_cursor/pages/right_big_1_page.dart';
import 'package:one_handed_cursor/pages/right_big_1_page_continuous.dart';
import 'package:one_handed_cursor/pages/right_small_1.5_page.dart';
import 'package:one_handed_cursor/pages/right_small_1_page.dart';
import 'package:one_handed_cursor/pages/right_small_1_page_continuous.dart';

String participantID = '';


void exportCSV() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd_kkmm').format(now);
  String rowsNoCursorCSV = const ListToCsvConverter().convert(rowsNoCursor);
  FileStorage.writeCounter(rowsNoCursorCSV, "rowsNoCursor-$formattedDate.csv");

  String rowsCursorCSV = const ListToCsvConverter().convert(rowsCursor);
  FileStorage.writeCounter(rowsCursorCSV, "rowsCursor-$formattedDate.csv");

  String continuousRowsNoCursorCSV =
      const ListToCsvConverter().convert(continuousRowsNoCursor);
  FileStorage.writeCounter(
      continuousRowsNoCursorCSV, "continuousRowsNoCursor-$formattedDate.csv");

  String continuousRowsCursorCSV =
      const ListToCsvConverter().convert(continuousRowsCursor);
  FileStorage.writeCounter(
      continuousRowsCursorCSV, "continuousRowsCursor-$formattedDate.csv");

  Fluttertoast.showToast(
      msg: "CSV files exported to device storage",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 20.0);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Custom Cursor'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList.list(children: [
                  // participant id
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownMenu<int>(
                        hintText: 'Select Participant ID',
                        width: 370,
                        menuHeight: 300,
                        onSelected: (int? newValue) {
                          // Do something with the selected value
                          participantID = newValue.toString();
                        },
                        dropdownMenuEntries:
                            List<DropdownMenuEntry<int>>.generate(
                          20,
                          (index) => DropdownMenuEntry<int>(
                              value: index + 1, label: (index + 1).toString()),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  // basic cursor page
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BasicCursorPage()));
                      },
                      child: const Text("Basic Cursor and Touchpad")),

                  const SizedBox(height: 10),
                  // gesture detector page
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GestureDetectorPage()));
                      },
                      child: const Text("Gesture Detector")),
                  const SizedBox(height: 10),
                  // generate cursor page
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const GenerateCursorPage()));
                      },
                      child: const Text("Generate Cursor")),
                  const SizedBox(height: 50),
                  // basic target page
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BasicTargetPage()));
                      },
                      child: const Text("Basic Targets")),
                  const SizedBox(height: 10),
                  //basic target page large
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BasicTargetPageLarge()));
                      },
                      child: const Text("Basic Targets Large")),
                  const SizedBox(height: 10),
                  // continuous target page
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ContinuousTargetPage()));
                      },
                      child: const Text("Continuous Targets")),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ContinuousTargetPageLarge()));
                      },
                      child: const Text("Continuous Targets Large")),
                  const SizedBox(height: 50),
                ]),
                const SliverPadding(padding: EdgeInsets.only(top: 10)),
                SliverGrid.count(
                    childAspectRatio: (1 / .4),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LeftSmall1Page()));
                          },
                          child: const Text("Left small 1")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RightSmall1Page()));
                          },
                          child: const Text("Right small 1")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LeftSmall15Page()));
                          },
                          child: const Text("Left small 1.5")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RightSmall15Page()));
                          },
                          child: const Text("Right small 1.5")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LeftBig1Page()));
                          },
                          child: const Text("Left big 1")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RightBig1Page()));
                          },
                          child: const Text("Right big 1")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LeftBig15Page()));
                          },
                          child: const Text("Left big 1.5")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RightBig15Page()));
                          },
                          child: const Text("Right big 1.5")),
                      // continuous pages
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LeftSmall1ContinuousPage()));
                          },
                          child: const Text("Left small 1 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RightSmall1ContinuousPage()));
                          },
                          child: const Text("Right small 1 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LeftSmall15ContinuousPage()));
                          },
                          child: const Text("Left small 1.5 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RightSmall1ContinuousPage()));
                          },
                          child: const Text("Right small 1.5 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LeftBig1ContinuousPage()));
                          },
                          child: const Text("Left big 1 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RightBig1ContinuousPage()));
                          },
                          child: const Text("Right big 1 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LeftBig1ContinuousPage()));
                          },
                          child: const Text("Left big 1.5 continuous")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RightBig15ContinuousPage()));
                          },
                          child: const Text("Right big 1.5 continuous")),
                    ]),
                SliverList.list(children: [
                  ElevatedButton(
                      onPressed: () {
                        exportCSV();
                      },
                      child: const Text("Export to CSV")),
                ]),
              ],
            )));
  }
}
