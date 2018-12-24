import 'package:flutter/material.dart';
import 'package:minesweeper/GameScreen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'minesweeper',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter Minesweeper"),
        ),
        body: Builder(
          builder: (context) {
            return Container(
              margin:
                  EdgeInsets.only(left: 60, right: 60, bottom: 80, top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _makeButton(context, name: "Very Easy", dim: 8, mines: 6),
                  Divider(),
                  _makeButton(context, name: "Easy", dim: 8, mines: 10),
                  Divider(),
                  _makeButton(context, name: "Medium", dim: 15, mines: 40),
                  Divider(),
                  _makeButton(context, name: "Hard", dim: 20, mines: 80),
                  Divider(),
                  _makeButton(context, name: "Very Hard", dim: 20, mines: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _makeButton(context, {name, dim, mines}) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.fill,
        child: GestureDetector(
          child: Container(
              color: Colors.greenAccent,
              height: 40,
              width: 100,
              child: Center(child: Text("$name"))),
          onTap: () {
            _startGame(context, dim, mines);
          },
        ),
      ),
    );
  }

  void _startGame(context, dim, mines) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => GameScreen(
              gameController: GameController(),
              dim: dim,
              mines: mines,
            )));
  }
}
