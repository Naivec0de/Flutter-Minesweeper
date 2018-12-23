import 'package:flutter/material.dart';
import 'package:minesweeper/GameBoard.dart';
import 'package:minesweeper/TimerDisplay.dart';

void main() => runApp(MyApp(GameController()));

class MyApp extends StatelessWidget {
  final GameController gameController;

  MyApp(this.gameController) {
    gameController.injectDependencies();
  }

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
        body: Builder(
          builder: (context) {
            gameController.setBuildContext(context);
            return Column(
              children: <Widget>[
                gameController.timerDisplay,
                gameController.gameBoard,
              ],
            );
          },
        ),
      ),
    );
  }
}

class GameController {
  TimerDisplay timerDisplay;
  TimerState timerState;
  GameBoard gameBoard;
  GameState gameState;

  void injectDependencies() {
    this.timerState = TimerState();
    this.timerDisplay = TimerDisplay(this, timerState);
    this.gameState = GameState();
    this.gameBoard = GameBoard(this, gameState);
  }

  var context;

  void setBuildContext(context) {
    this.context = context;
  }

  void resetGame() {
    gameState.resetBoard();
    timerState.reset();
  }

  void startTimer() {
    timerState.start();
  }

  void win() {
    timerState.stop();

    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("You won!"),
    ));
  }

  void lose() {
    timerState.stop();

    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("You lost."),
    ));
  }
}
