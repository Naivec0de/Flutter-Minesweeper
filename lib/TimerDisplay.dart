import 'dart:async';

import 'package:flutter/material.dart';

class TimerDisplay extends StatefulWidget {
  final gameController;
  final timerState;

  TimerDisplay(this.gameController, this.timerState);

  @override
  State createState() => timerState;
}

class TimerState extends State<TimerDisplay> {
  int ticks = 0;
  bool started = false;
  bool stopped = false;
  Timer timer;

  void start() {
    if (started || stopped) {
      print("start timer failed");
      return;
    }
    started = true;
    print("start timer successful");
    Timer.periodic(new Duration(seconds: 1), (timer) {
      this.timer = timer;
      if (stopped) {
        timer.cancel();
      } else {
        setState(() {
          ticks += 1;
        });
      }
    });
  }

  void stop() {
    print("stopping timer $timer");
    stopped = true;
  }

  void reset() {
    if (timer != null) {
      timer.cancel();
    }
    started = false;
    stopped = false;
    setState(() {
      ticks = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.gameController.resetGame();
        },
        child: Container(
          height: 30,
          width: 120,
          color: Colors.blue[100],
          child: Center(
            child: Text(
              '$ticks',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
        ));
  }
}
