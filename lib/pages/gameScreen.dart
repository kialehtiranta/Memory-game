import 'package:flutter/material.dart';
import 'package:flutter_application_2/widgets/cardList.dart';
import 'package:get/get.dart';
import '../controllers/cardController.dart';
import '../main.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cardController = Get.find<CardController>();
    return GameScaffold(
      content: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GameButton(text: "Back", onPressed: () => Get.back()),
            Obx(
              () => Text(
                "Attempts: ${cardController.attempts.value}",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.all(16)),
        CardList(),
      ],
    );
  }
}
