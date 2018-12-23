import 'package:flutter/material.dart';

class TimerDisplay extends StatefulWidget {
  @override
  State createState() => TimerState();

  void start() {}

  void stop() {}
}

class TimerState extends State<TimerDisplay> {
  @override
  Widget build(BuildContext context) {
    return Text("My Timer");
  }
}
