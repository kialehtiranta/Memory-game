import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controllers/cardController.dart';
import 'services/levelService.dart';
import 'pages/startScreen.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox('gameProgress');

  final levelService = LevelService(box);
  Get.put(levelService, permanent: true);
  Get.put(CardController(), permanent: true);
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: CustomScrollBehavior(),
      home: StartScreen(),
      theme: ThemeData(textTheme: GoogleFonts.fredokaTextTheme()),
    );
  }
}

class GameScaffold extends StatelessWidget {
  final List<Widget> content;
  const GameScaffold({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: content,
            ),
          ),
        ),
      ),
    );
  }
}

class GameButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? backgroundColor;

  const GameButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ?? const Color.fromARGB(255, 247, 211, 247),
      ),
      onPressed: () => onPressed(),
      child: Text(text, style: const TextStyle(fontSize: 22)),
    );
  }
}
