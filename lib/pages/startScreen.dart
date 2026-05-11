import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import 'levelScreen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      content: [
        Text("Welcome to the game!", style: TextStyle(fontSize: 48)),
        Padding(padding: EdgeInsets.all(16)),
        GameButton(text: "Start", onPressed: () => Get.to(LevelScreen())),
      ],
    );
  }
}
