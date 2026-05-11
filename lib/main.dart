import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';

import 'services/levelService.dart';
import 'pages/startScreen.dart';

const questions = [
  {"question": "Is the sun a star?", "answer": true},
  {"question": "Is the earth flat?", "answer": false},
  {"question": "Is the moon made of cheese?", "answer": false},
];

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LevelService());
    return GetMaterialApp(home: StartScreen());
  }
}

class GameScaffold extends StatelessWidget {
  final List<Widget> content;
  const GameScaffold({required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: content,
        ),
      ),
    );
  }
}

class GameButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const GameButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(text, style: TextStyle(fontSize: 24)),
    );
  }
}
