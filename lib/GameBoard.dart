import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper/GameScreen.dart';

int _dim = 8;
int _mines = 10;

List<List<CellState>> _board = List.generate(
    _dim, (i) => List<CellState>.generate(_dim, (j) => CellState(i, j)));

GameController gameController;

class GameBoard extends StatefulWidget {
  final gameState;

  GameBoard(gameCtrl, this.gameState) {
    gameController = gameCtrl;
  }

  @override
  State createState() => gameState;
}

class GameState extends State<GameBoard> {
  GameState(int dim, int mines) {
    _dim = dim;
    _mines = mines;
  }

  @override
  void initState() {
    resetBoard();

    super.initState();
  }

  void resetBoard() {
    _board.expand((row) => row).forEach((cell) => cell.reset());

    Random rnd = Random();
    // place mines:
    if (_mines > _dim * _dim) {
      throw Exception("Too many mines on such tiny board.");
    }
    for (int i = 0; i < _mines; i++) {
      int x, y;
      do {
        x = rnd.nextInt(_dim);
        y = rnd.nextInt(_dim);
      } while (_board[x][y].isMine());
      _board[x][y].setMine();
    }
    // calc nearby numbers:
    _board.expand((row) => row).where((cell) => !cell.isMine()).forEach((cell) {
      cell.nearby = cell
          .getNearbyCells()
          .map((cell) => cell.isMine() ? 1 : 0)
          .reduce((acc, cell) => acc + cell);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("building a $_dim x $_dim board.");
    final col = <Widget>[];
    for (int i = 0; i < _dim; i++) {
      final row = <Widget>[];
      for (int j = 0; j < _dim; j++) {
        final cell = GameCell(i, j);
        row.add(cell);
      }
      col.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: row,
      ));
    }
    return Column(children: col);
  }
}

class GameCell extends StatefulWidget {
  final int i, j;

  GameCell(this.i, this.j);

  @override
  State createState() => _board[i][j];
}

class CellState extends State<GameCell> {
  int x, y;
  bool revealed = false;
  bool flagged = false;
  int nearby = 0; // -1 is MINE, non-negative numbers are nearby indicators

  CellState(this.x, this.y);

  reset() {
    revealed = false;
    flagged = false;
    nearby = 0;
  }

  bool isMine() {
    return nearby == -1;
  }

  void setMine() {
    nearby = -1;
  }

  void endGame(bool won) {
    if (isMine()) {
      setState(() {
        if (won) {
          flagged = true;
        } else {
          revealed = true;
        }
      });
    }
  }

  void reveal() {
    if (flagged) return;

    setState(() {
      revealed = true;
    });

    // lose condition:
    if (isMine()) {
      gameController.endGame(false);
      _board.expand((row) => row).forEach((cell) => cell.endGame(false));
    }

    // win condition:
    int unrevealed = _board
        .expand((row) => row)
        .map((cell) => cell.revealed ? 0 : 1)
        .reduce((acc, it) => acc + it);
    if (unrevealed == _mines) {
      gameController.endGame(true);
      _board.expand((row) => row).forEach((cell) => cell.endGame(true));
    }

    // auto click, if nearby flags matches nearby mines:
    int flagsNearby = getNearbyCells()
        .map((cell) => cell.flagged ? 1 : 0)
        .reduce((acc, v) => acc + v);
    if (flagsNearby == nearby) {
      getNearbyCells()
          .where((cell) => !cell.revealed)
          .forEach((cell) => cell.reveal());
    }
  }

  List<CellState> getNearbyCells() {
    return [
      Point(x - 1, y - 1),
      Point(x - 1, y + 1),
      Point(x - 1, y),
      Point(x + 1, y - 1),
      Point(x + 1, y + 1),
      Point(x + 1, y),
      Point(x, y - 1),
      Point(x, y + 1),
    ]
        .where((pt) => pt.x >= 0 && pt.x < _dim && pt.y >= 0 && pt.y < _dim)
        .map((pt) => _board[pt.x][pt.y])
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.fill,
        child: GestureDetector(
          onLongPress: () {
            if (!revealed) {
              // flag current cell:
              setState(() {
                flagged = !flagged;
              });
            }
          },
          onTap: () {
            gameController.startTimer();
            reveal();
          },
          child: Container(
            margin: EdgeInsets.all(2.0),
            height: 30.0,
            width: 30.0,
            color: flagged
                ? Colors.red[300]
                : revealed ? Colors.grey[300] : Colors.grey,
            child: Center(
              child: revealed
                  ? (isMine()
                      ? Icon(
                          Icons.brightness_high,
                          color: Colors.black,
                        )
                      : Text(
                          nearby == 0 ? "" : '$nearby',
                          style: TextStyle(fontSize: 24),
                        ))
                  : Text(""),
            ),
          ),
        ),
      ),
    );
  }
}
