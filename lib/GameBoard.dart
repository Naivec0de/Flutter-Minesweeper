import 'dart:math';

import 'package:flutter/material.dart';

const int _dim = 8;
const _mines = 10;
const MINE = -1; // denotes the cell contains a MINE

List<List<CellState>> _board = List.generate(
    _dim, (i) => List<CellState>.generate(_dim, (j) => CellState(i, j)));

class GameBoard extends StatefulWidget {
  @override
  State createState() => GameState();
}

class GameState extends State<GameBoard> {
  @override
  void initState() {
    _resetBoard();

    super.initState();
  }

  void _resetBoard() {
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
    for (int i = 0; i < _dim; i++) {
      for (int j = 0; j < _dim; j++) {
        if (_board[i][j].isMine()) {
          continue;
        }
        _board[i][j].nearby = _board[i][j]
            .getNearbyCells()
            .map((cell) => cell.isMine() ? 1 : 0)
            .reduce((acc, cell) => acc + cell);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBoard();
  }

  Widget _buildBoard() {
    final col = <Widget>[];
    for (int i = 0; i < _dim; i++) {
      final row = <Widget>[];
      for (int j = 0; j < _dim; j++) {
        final cell = GameCell(i, j);
        row.add(cell);
      }
      col.add(Row(children: row));
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

  bool isMine() {
    return nearby == -1;
  }

  void setMine() {
    nearby = -1;
  }

  void reveal() {
    if (revealed || flagged) return;

    setState(() {
      revealed = true;
    });

    // auto click, if the cell is completely safe
    if (nearby == 0) {
      getNearbyCells().forEach((cell) => cell.reveal());
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
    return GestureDetector(
      onLongPress: () {
        if (!revealed) {
          // flag current cell:
          setState(() {
            flagged = !flagged;
          });
        }
      },
      onTap: reveal,
      child: Container(
        margin: EdgeInsets.all(2.0),
        height: 40.0,
        width: 40.0,
        color: flagged ? Colors.red : revealed ? Colors.white : Colors.grey,
//        color: isMine() ? Colors.red : Colors.white,
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
    );
  }
}
