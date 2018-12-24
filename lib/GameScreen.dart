import 'package:flutter/material.dart';
import 'package:minesweeper/GameBoard.dart';
import 'package:minesweeper/TimerDisplay.dart';

class GameScreen extends StatelessWidget {
  final GameController gameController;
  final int dim, mines;

  GameScreen({this.gameController, this.dim, this.mines}) {
    gameController.injectDependencies(dim, mines);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minesweeper $dim x $dim, mines: $mines."),
      ),
      body: Builder(
        builder: (context) {
          gameController.setBuildContext(context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              gameController.timerDisplay,
              Divider(),
              gameController.gameBoard,
            ],
          );
        },
      ),
    );
  }
}

class GameController {
  TimerDisplay timerDisplay;
  TimerState timerState;
  GameBoard gameBoard;
  GameState gameState;

  void injectDependencies(dim, mines) {
    this.timerState = TimerState();
    this.timerDisplay = TimerDisplay(this, timerState);
    this.gameState = GameState(dim, mines);
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

  void endGame(bool won) {
    timerState.stop();

    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("You ${won ? 'won!' : 'lost.'}"),
      action: SnackBarAction(
        label: "Reset",
        onPressed: () {
          resetGame();
        },
      ),
    ));
  }
}
