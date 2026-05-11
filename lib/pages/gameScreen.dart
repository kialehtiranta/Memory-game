import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import 'resultScreen.dart';
import '../services/levelService.dart';

class GameScreen extends StatelessWidget {
  var questionIndex = 0.obs;
  var score = 0.obs;

  _answerQuestion(bool answer) {
    var answerCorrect = questions[questionIndex.value]["answer"] == answer;
    if (answerCorrect) {
      score.value++;
    }

    if (questionIndex.value < questions.length - 1) {
      questionIndex.value++;
    } else {
      final levelService = Get.find<LevelService>();
      if (score.value == questions.length) {
        levelService.completedLevels.add(levelService.currentLevel);
      }
      Get.to(ResultScreen(score: score.value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      content: [
        Obx(
          () => Text(
            questions[questionIndex.value]["question"] as String,
            style: TextStyle(fontSize: 48),
          ),
        ),
        Padding(padding: EdgeInsets.all(16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GameButton(text: "Yes", onPressed: () => _answerQuestion(true)),
            Padding(padding: EdgeInsets.all(16)),
            GameButton(text: "No", onPressed: () => _answerQuestion(false)),
          ],
        ),
      ],
    );
  }
}
