import 'dart:math';

import 'package:flutter_application_2/services/levelService.dart';
import 'package:flutter_application_2/pages/levelScreen.dart';
import 'package:flutter_application_2/pages/resultScreen.dart';
import 'package:get/get.dart';

class MemoryCard {
  final String imagePath;
  final revealed = false.obs;

  MemoryCard(this.imagePath);
}

class CardController {
  static const imageAssetPaths = [
    "assets/aurinko0.jpg",
    "assets/coffee.jpg",
    "assets/estudio-bloom-oo3kSFZ7uHk-unsplash.jpg",
    "assets/giorgio-trovato-fczCr7MdE7U-unsplash.jpg",
    "assets/jaro_n-lemon-1024641_640.jpg",
    "assets/jo-sonn-zeFy-oCUhV8-unsplash.jpg",
    "assets/karhu.jpg",
    "assets/koivu0.jpg",
    "assets/kukat0.jpg",
    "assets/kukka0.jpg",
    "assets/lasi.jpg",
    "assets/laventeli0.jpg",
    "assets/leaf.jpg",
    "assets/lemon.jpg",
    "assets/lewis-fagg-Nl7eLS8E2Ss-unsplash.jpg",
    "assets/mae-mu-U1iYwZ8Dx7k-unsplash.jpg",
    "assets/mae-mu-vbAEHCrvXZ0-unsplash.jpg",
    "assets/melon.jpg",
    "assets/pallo0.jpg",
    "assets/rypsyt.jpg",
    "assets/shamblen-studios-euqiHwS38Rw-unsplash.jpg",
    "assets/stephany-williams-yx3-a7ualMM-unsplash.jpg",
    "assets/tangerine-newt-63jVvJAIfpI-unsplash.jpg",
    "assets/tangerine-newt-a9rxefN9vgY-unsplash.jpg",
    "assets/thought-catalog-9aOswReDKPo-unsplash.jpg",
    "assets/tijana-drndarski-ta0b_NDxi6k-unsplash.jpg",
    "assets/vattu.png",
  ];

  final cards = RxList<MemoryCard>();
  final attempts = 0.obs;
  final _random = Random();
  int? _firstSelectedIndex;
  bool _blockingSelection = false;

  CardController() {
    generateLevelCards(0);
  }

  int gridDimensionForLevel(int level) => 2 + level * 2;

  void generateLevelCards(int level) {
    final dimension = gridDimensionForLevel(level);
    final cellCount = dimension * dimension;
    final uniqueCount = (cellCount ~/ 2).clamp(1, imageAssetPaths.length);

    final selectedAssets = List.of(imageAssetPaths)..shuffle(_random);
    final levelAssets = selectedAssets.take(uniqueCount).toList();

    final cardAssets = levelAssets.expand((path) => [path, path]).toList();
    cardAssets.shuffle(_random);

    cards.value = cardAssets.map((path) => MemoryCard(path)).toList();
    _firstSelectedIndex = null;
    _blockingSelection = false;
    attempts.value = 0;
  }

  void toggleCard(int index) {
    if (_blockingSelection) return;
    if (index < 0 || index >= cards.length) return;

    final card = cards[index];
    if (card.revealed.value) return;

    card.revealed.value = true;

    if (_firstSelectedIndex == null) {
      _firstSelectedIndex = index;
      return;
    }

    final firstIndex = _firstSelectedIndex!;
    if (firstIndex == index) return;

    final firstCard = cards[firstIndex];
    if (firstCard.imagePath != card.imagePath) {
      attempts.value++;
      _blockingSelection = true;
      Future.delayed(const Duration(milliseconds: 700), () {
        firstCard.revealed.value = false;
        card.revealed.value = false;
        _firstSelectedIndex = null;
        _blockingSelection = false;
      });
    } else {
      attempts.value++;
      _firstSelectedIndex = null;
      _checkLevelCompletion();
    }
  }

  void _checkLevelCompletion() {
    if (cards.every((card) => card.revealed.value)) {
      final levelService = Get.find<LevelService>();
      levelService.addCompletedLevel(levelService.currentLevel);
      levelService.addAttempts(attempts.value);

      final completedAll =
          levelService.completedLevels.length >= levelService.totalLevels;
      if (completedAll) {
        Get.defaultDialog(
          title: 'Congratulations!',
          middleText: 'You completed all levels!',
          barrierDismissible: false,
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
          Get.off(() => ResultScreen(score: levelService.totalAttempts));
        });
      } else {
        Get.snackbar(
          "Congratulations!",
          "You completed level ${levelService.currentLevel + 1}!",
          duration: const Duration(seconds: 2),
        );
        Future.delayed(const Duration(seconds: 2), () {
          Get.off(() => LevelScreen());
        });
      }
    }
  }
}
