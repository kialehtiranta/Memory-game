import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import 'levelScreen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  const ResultScreen({required this.score});
  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      content: [
        Text(
          "Your final score was $score / ${questions.length}",
          style: TextStyle(fontSize: 48),
        ),
        Padding(padding: EdgeInsets.all(16)),
        GameButton(
          text: "Choose next level",
          onPressed: () => Get.to(LevelScreen()),
        ),
      ],
    );
  }
}
