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
import 'package:one_handed_cursor/pages/left_large_1.5_page.dart';
import 'package:one_handed_cursor/pages/left_continuous_large_1.5_page.dart';
import 'package:one_handed_cursor/pages/left_large_1_page.dart';
import 'package:one_handed_cursor/pages/left_continuous_large_1_page.dart';
import 'package:one_handed_cursor/pages/left_small_1.5_page.dart';
import 'package:one_handed_cursor/pages/left_continuous_small_1.5_page.dart';
import 'package:one_handed_cursor/pages/left_small_1_page.dart';
import 'package:one_handed_cursor/pages/left_continuous_small_1_page.dart';
import 'package:one_handed_cursor/pages/right_continuous_small_1.5_page.dart';
import 'package:one_handed_cursor/pages/right_large_1.5_page.dart';
import 'package:one_handed_cursor/pages/right_continuous_large_1.5_page.dart';
import 'package:one_handed_cursor/pages/right_large_1_page.dart';
import 'package:one_handed_cursor/pages/right_continuous_large_1_page.dart';
import 'package:one_handed_cursor/pages/right_small_1.5_page.dart';
import 'package:one_handed_cursor/pages/right_small_1_page.dart';
import 'package:one_handed_cursor/pages/right_continuous_small_1_page.dart';

String participantID = '';
String participantHand = '';

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
  ElevatedButton getButton(String text, Widget Function() page) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Builder(
                        builder: (BuildContext context) => page(),
                      )));
        },
        child: Text(text));
  }

  int ddmIdValue = 0;
  String ddmHandValue = '';

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
                        initialSelection: ddmIdValue,
                        hintText: 'Select Participant ID',
                        width: 370,
                        menuHeight: 300,
                        onSelected: (int? newValue) {
                          // Do something with the selected value
                          setState(() {
                            participantID = newValue.toString();
                            ddmIdValue = newValue!;
                          });
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

                  // dominant hand
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownMenu(
                          initialSelection: ddmHandValue,
                          hintText: 'Select dominant hand',
                          width: 370,
                          menuHeight: 300,
                          onSelected: (String? newValue) {
                            // Do something with the selected value
                            setState(() {
                              participantHand = newValue!;
                              ddmHandValue = newValue;
                            });
                          },
                          dropdownMenuEntries: const <DropdownMenuEntry<
                              String>>[
                            DropdownMenuEntry<String>(
                                value: 'left', label: 'Left'),
                            DropdownMenuEntry<String>(
                                value: 'right', label: 'Right')
                          ]),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // basic cursor page
                  getButton("Basic Cursor and Touchpad",
                      () => const BasicCursorPage()),
                  const SizedBox(height: 10),

                  // gesture detector page
                  getButton(
                      "Gesture Detector", () => const GestureDetectorPage()),
                  const SizedBox(height: 10),

                  // generate cursor page
                  getButton(
                      "Generate Cursor", () => const GenerateCursorPage()),
                  const SizedBox(height: 50),

                  //basic target page large
                  getButton("Basic Targets Large",
                      () => const BasicTargetPageLarge()),
                  const SizedBox(height: 10),

                  // basic target page
                  getButton(
                      "Basic Targets Small", () => const BasicTargetPage()),
                  const SizedBox(height: 10),

                  // continuous target page large
                  getButton("Continuous Targets Large",
                      () => const ContinuousTargetPageLarge()),
                  const SizedBox(height: 10),

                  // continuous target page
                  getButton("Continuous Targets Small",
                      () => const ContinuousTargetPage()),
                  const SizedBox(height: 50),
                ]),
                const SliverPadding(padding: EdgeInsets.only(top: 10)),

                // participant 1, 5, 9, 13, 17
                if (ddmIdValue == 1 ||
                    ddmIdValue == 5 ||
                    ddmIdValue == 9 ||
                    ddmIdValue == 13 ||
                    ddmIdValue == 17)
                  if (ddmHandValue == 'left')
                    SliverList.list(children: [
                      // circle
                      getButton("Left Circle Large CD:1",
                          () => const LeftLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Small CD:1",
                          () => const LeftSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Large CD:1.5",
                          () => const LeftLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Small CD:1.5",
                          () => const LeftSmall15Page()),
                      const SizedBox(height: 30),

                      // square
                      getButton("Left Square Large CD:1",
                          () => const LeftLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Small CD:1",
                          () => const LeftSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Large CD:1.5",
                          () => const LeftLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Small CD:1.5",
                          () => const LeftSmall15Page()),
                      const SizedBox(height: 30),

                      // continuous
                      getButton("Left Continuous Large CD:1",
                          () => const LeftContinuousLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Continuous Small CD:1",
                          () => const LeftContinuousSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Continuous Large CD:1.5",
                          () => const LeftContinuousLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Continuous Small CD:1.5",
                          () => const LeftContinuousSmall15Page()),
                      const SizedBox(height: 30),
                    ]),
                // participant 1, 5, 9, 13, 17
                if (ddmIdValue == 1 ||
                    ddmIdValue == 5 ||
                    ddmIdValue == 9 ||
                    ddmIdValue == 13 ||
                    ddmIdValue == 17)
                  if (ddmHandValue == 'right')
                    SliverList.list(children: [
                      // circle
                      getButton("Right Circle Large CD:1",
                          () => const RightLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Small CD:1",
                          () => const RightSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Large CD:1.5",
                          () => const RightLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Small CD:1.5",
                          () => const RightSmall1Page()),
                      const SizedBox(height: 30),

                      // square
                      getButton("Right Square Large CD:1",
                          () => const RightLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Small CD:1",
                          () => const RightSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Large CD:1.5",
                          () => const RightLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Small CD:1.5",
                          () => const RightSmall1Page()),
                      const SizedBox(height: 30),

                      // continuous
                      getButton("Right Continuous Large CD:1",
                          () => const RightContinuousLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Continuous Small CD:1",
                          () => const RightContinuousSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Continuous Large CD:1.5",
                          () => const RightContinuousLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Continuous Small CD:1.5",
                          () => const RightContinuousSmall15Page()),
                      const SizedBox(height: 30),
                    ]),

                // participant 2, 6, 10, 14, 18
                if (ddmIdValue == 2 ||
                    ddmIdValue == 6 ||
                    ddmIdValue == 10 ||
                    ddmIdValue == 14 ||
                    ddmIdValue == 18)
                  if (ddmHandValue == 'left')
                    SliverList.list(children: [
                      // square
                      getButton("Left Square Large CD:1",
                          () => const LeftLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Small CD:1",
                          () => const LeftSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Large CD:1.5",
                          () => const LeftLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Small CD:1.5",
                          () => const LeftSmall15Page()),
                      const SizedBox(height: 30),

                      // circle
                      getButton("Left Circle Large CD:1",
                          () => const LeftLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Small CD:1",
                          () => const LeftSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Large CD:1.5",
                          () => const LeftLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Small CD:1.5",
                          () => const LeftSmall15Page()),
                      const SizedBox(height: 30),

                      // continuous
                      getButton("Left Continuous Large CD:1",
                          () => const LeftContinuousLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Continuous Small CD:1",
                          () => const LeftContinuousSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Continuous Large CD:1.5",
                          () => const LeftContinuousLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Continuous Small CD:1.5",
                          () => const LeftContinuousSmall15Page()),
                      const SizedBox(height: 30),
                    ]),
                if (ddmIdValue == 2 ||
                    ddmIdValue == 6 ||
                    ddmIdValue == 10 ||
                    ddmIdValue == 14 ||
                    ddmIdValue == 18)
                  if (ddmHandValue == 'right')
                    SliverList.list(children: [
                      // square
                      getButton("Right Square Large CD:1",
                          () => const RightLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Small CD:1",
                          () => const RightSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Large CD:1.5",
                          () => const RightLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Small CD:1.5",
                          () => const RightSmall15Page()),
                      const SizedBox(height: 30),

                      // circle
                      getButton("Right Circle Large CD:1",
                          () => const RightLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Small CD:1",
                          () => const RightSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Large CD:1.5",
                          () => const RightLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Small CD:1.5",
                          () => const RightSmall15Page()),
                      const SizedBox(height: 30),

                      // continuous
                      getButton("Right Continuous Large CD:1",
                          () => const RightContinuousLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Continuous Small CD:1",
                          () => const RightContinuousSmall1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Continuous Large CD:1.5",
                          () => const RightContinuousLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Continuous Small CD:1.5",
                          () => const RightContinuousSmall15Page()),
                      const SizedBox(height: 30),
                    ]),

                // participant 3, 7, 11, 15, 19
                if (ddmIdValue == 3 ||
                    ddmIdValue == 7 ||
                    ddmIdValue == 11 ||
                    ddmIdValue == 15 ||
                    ddmIdValue == 19)
                  if (ddmHandValue == 'left')
                    SliverList.list(children: [
                      // circle
                      getButton("Left Circle Large CD:1.5",
                          () => const LeftLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Small CD:1.5",
                          () => const LeftSmall15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Large CD:1",
                          () => const LeftLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Small CD:1",
                          () => const LeftSmall1Page()),
                      const SizedBox(height: 30),

                      // square
                      getButton("Left Square Large CD:1.5",
                          () => const LeftLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Small CD:1.5",
                          () => const LeftSmall15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Large CD:1",
                          () => const LeftLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Small CD:1",
                          () => const LeftSmall1Page()),
                      const SizedBox(height: 30),

                      // continuous
                      getButton("Left Continuous Large CD:1.5",
                          () => const LeftContinuousLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Continuous Small CD:1.5",
                          () => const LeftContinuousSmall15Page()),
                      getButton("Left Continuous Large CD:1",
                          () => const LeftContinuousLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Continuous Small CD:1",
                          () => const LeftContinuousSmall1Page()),
                      const SizedBox(height: 30),
                    ]),
                if (ddmIdValue == 3 ||
                    ddmIdValue == 7 ||
                    ddmIdValue == 11 ||
                    ddmIdValue == 15 ||
                    ddmIdValue == 19)
                  if (ddmHandValue == 'right')
                    SliverList.list(children: [
                      // circle
                      getButton("Right Circle Large CD:1.5",
                          () => const RightLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Small CD:1.5",
                          () => const RightSmall15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Large CD:1",
                          () => const RightLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Small CD:1",
                          () => const RightSmall1Page()),
                      const SizedBox(height: 30),

                      // square
                      getButton("Right Square Large CD:1.5",
                          () => const RightLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Small CD:1.5",
                          () => const RightSmall15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Large CD:1",
                          () => const RightLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Small CD:1",
                          () => const RightSmall1Page()),
                      const SizedBox(height: 30),

                      // continuous
                      getButton("Right Continuous Large CD:1.5",
                          () => const RightContinuousLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Continuous Small CD:1.5",
                          () => const RightContinuousSmall15Page()),
                      getButton("Right Continuous Large CD:1",
                          () => const RightContinuousLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Continuous Small CD:1",
                          () => const RightContinuousSmall1Page()),
                      const SizedBox(height: 30),
                    ]),

                // participant 4, 8, 12, 16, 20
                if (ddmIdValue == 4 ||
                    ddmIdValue == 8 ||
                    ddmIdValue == 12 ||
                    ddmIdValue == 16 ||
                    ddmIdValue == 20)
                  if (ddmHandValue == 'left')
                    SliverList.list(children: [
                      // square
                      getButton("Left Square Large CD:1.5",
                          () => const LeftLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Small CD:1.5",
                          () => const LeftSmall15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Large CD:1",
                          () => const LeftLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Square Small CD:1",
                          () => const LeftSmall1Page()),
                      const SizedBox(height: 30),

                      // circle
                      getButton("Left Circle Large CD:1.5",
                          () => const LeftLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Small CD:1.5",
                          () => const LeftSmall15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Large CD:1",
                          () => const LeftLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Circle Small CD:1",
                          () => const LeftSmall1Page()),
                      const SizedBox(height: 30),

                      // continuous
                      getButton("Left Continuous Large CD:1.5",
                          () => const LeftContinuousLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Left Continuous Small CD:1.5",
                          () => const LeftContinuousSmall1Page()),
                      getButton("Left Continuous Large CD:1",
                          () => const LeftContinuousLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Left Continuous Small CD:1",
                          () => const LeftContinuousSmall1Page()),
                      const SizedBox(height: 30),
                    ]),
                if (ddmIdValue == 4 ||
                    ddmIdValue == 8 ||
                    ddmIdValue == 12 ||
                    ddmIdValue == 16 ||
                    ddmIdValue == 20)
                  if (ddmHandValue == 'right')
                    SliverList.list(children: [
                      // square
                      getButton("Right Square Large CD:1.5",
                          () => const RightLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Small CD:1.5",
                          () => const RightSmall15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Large CD:1",
                          () => const RightLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Square Small CD:1",
                          () => const RightSmall1Page()),
                      const SizedBox(height: 30),

                      // circle
                      getButton("Right Circle Large CD:1.5",
                          () => const RightLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Small CD:1.5",
                          () => const RightSmall15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Large CD:1",
                          () => const RightLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Circle Small CD:1",
                          () => const RightSmall1Page()),
                      const SizedBox(height: 30),

                      // continuous
                      getButton("Right Continuous Large CD:1.5",
                          () => const RightContinuousLarge15Page()),
                      const SizedBox(height: 10),
                      getButton("Right Continuous Small CD:1.5",
                          () => const RightContinuousSmall1Page()),
                      getButton("Right Continuous Large CD:1",
                          () => const RightContinuousLarge1Page()),
                      const SizedBox(height: 10),
                      getButton("Right Continuous Small CD:1",
                          () => const RightContinuousSmall1Page()),
                      const SizedBox(height: 30),
                    ]),

                // export to csv button
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
