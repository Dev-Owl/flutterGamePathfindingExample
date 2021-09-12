import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:mazeball2021/exampleGame.dart';

class MainGameScreen extends StatefulWidget {
  MainGameScreen({Key? key}) : super(key: key);

  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Builder(builder: (context) {
          return GameWidget(game: ExampleGame());
        }),
      ),
      onWillPop: () async => false, //Prevent leaving by back press
    );
  }
}
