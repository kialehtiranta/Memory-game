import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../main.dart';
import 'gameScreen.dart';
import 'startScreen.dart';
import '../services/levelService.dart';

class LevelScreen extends StatelessWidget {
  final levelService = Get.find<LevelService>();

  @override
  Widget build(BuildContext context) {
    final levels = Iterable.generate(levelService.totalLevels).expand((level) {
      return [
        Padding(padding: EdgeInsets.all(16)),
        GameButton(
          text:
              "Level ${level + 1} (${levelService.completedLevels.contains(level) ? "Completed" : "Not completed"})",
          onPressed: () {
            levelService.currentLevel = level;
            Get.to(GameScreen());
          },
        ),
      ];
    }).toList();

    return GameScaffold(
      content: [
        Text("Choose a level", style: TextStyle(fontSize: 48)),
        ...levels,
        Padding(padding: EdgeInsets.all(16)),
        GameButton(
          text: "Back to start",
          onPressed: () => Get.to(StartScreen()),
        ),
      ],
    );
  }
}
