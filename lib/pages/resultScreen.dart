import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import '../services/levelService.dart';
import 'startScreen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  const ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      content: [
        Text(
          "Your total score was $score attempts!",
          style: TextStyle(fontSize: 48),
        ),
        Padding(padding: EdgeInsets.all(16)),
        GameButton(
          text: "Start over",
          onPressed: () {
            final levelService = Get.find<LevelService>();
            levelService.resetProgress();
            Get.offAll(() => StartScreen());
          },
        ),
      ],
    );
  }
}
