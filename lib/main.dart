import 'package:flutter/material.dart';
import 'package:minesweeper/GameBoard.dart';
import 'package:minesweeper/TimerDisplay.dart';

void main() => runApp(MyApp());

TimerDisplay timer = TimerDisplay();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'minesweeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Minesweeper"),
        ),
        body: Column(
          children: <Widget>[
            timer,
            GameBoard(),
          ],
        ),
      ),
    );
  }
}
