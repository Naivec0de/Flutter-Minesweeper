import 'dart:math';

import 'package:flutter/material.dart';

const int _dim = 8;
const _mines = 10;
const MINE = -1; // denotes the cell contains a MINE

class GameBoard extends StatefulWidget {
  @override
  State createState() => GameState();
}

class GameState extends State<GameBoard> {
  List<List<int>> _board =
      List.generate(_dim, (i) => List<int>.filled(_dim, 0));

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
      } while (_board[x][y] == MINE);

      _board[x][y] = MINE;
    }
    // calc nearby numbers:
    int isMine(int i, int j) {
      if (i >= 0 && i < _dim && j >= 0 && j < _dim) {
        return _board[i][j] == MINE ? 1 : 0;
      }
      return 0;
    }

    for (int i = 0; i < _dim; i++) {
      for (int j = 0; j < _dim; j++) {
        if (_board[i][j] == MINE) {
          continue;
        }
        int count = 0;
        count += isMine(i - 1, j - 1);
        count += isMine(i - 1, j + 1);
        count += isMine(i - 1, j);
        count += isMine(i + 1, j - 1);
        count += isMine(i + 1, j + 1);
        count += isMine(i + 1, j);
        count += isMine(i, j - 1);
        count += isMine(i, j + 1);
        _board[i][j] = count;
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
        final cell = GameCell(count: _board[i][j]);
        row.add(cell);
      }
      col.add(Row(children: row));
    }
    return Column(children: col);
  }
}

class GameCell extends StatefulWidget {
  final int count;

  GameCell({this.count});

  @override
  State createState() => CellState(count: count);
}

class CellState extends State<GameCell> {
  bool revealed = false;
  bool flagged = false;
  int count = 0;

  CellState({this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (revealed) {
          // highlight nearby cells:
        } else {
          // flag current cell:
          setState(() {
            flagged = !flagged;
          });
        }
      },
      onTap: () {
        setState(() {
          revealed = true;
        });
      },
      child: Container(
        margin: EdgeInsets.all(2.0),
        height: 30.0,
        width: 30.0,
        color: flagged ? Colors.red : revealed ? Colors.white : Colors.grey,
        child: Text('$count'),
      ),
    );
  }
}
