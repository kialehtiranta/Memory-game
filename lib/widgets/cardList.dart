import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/controllers/cardController.dart';
import 'package:flutter_application_2/services/levelService.dart';
import 'package:get/get.dart';

class CardList extends StatelessWidget {
  final CardController cardController = Get.find<CardController>();
  final LevelService levelService = Get.find<LevelService>();

  int gridDimension(int level, double screenWidth) {
    if (screenWidth <= 420) {
      return 4;
    }
    return 2 + level * 2;
  }

  double cardSizeForLevel(int level) => level == 2 ? 80 : 100;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final cards = cardController.cards;
      final dimension = gridDimension(levelService.currentLevel, screenWidth);
      var cardSize = cardSizeForLevel(levelService.currentLevel);
      final spacing = 5.0;
      final padding = 5.0;

      // Calculate grid dimensions
      final gridWidth =
          dimension * cardSize + (dimension - 1) * spacing + padding * 2;
      final rowCount = (cards.length / dimension).ceil();
      final gridHeight =
          rowCount * cardSize + (rowCount - 1) * spacing + padding * 2;

      // Check if scrolling is needed
      final horizontalScrollNeeded = gridWidth > screenWidth;
      final verticalScrollNeeded =
          gridHeight > screenHeight - 100; // 100px buffer for other UI

      if (horizontalScrollNeeded || verticalScrollNeeded) {
        cardSize *= 0.7;
      }

      final finalGridWidth =
          dimension * cardSize + (dimension - 1) * spacing + padding * 2;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: finalGridWidth,
          child: GridView.count(
            crossAxisCount: dimension,
            childAspectRatio: 1,
            padding: EdgeInsets.all(padding),
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(cards.length, (index) {
              final card = cards[index];
              return Center(
                child: SizedBox(
                  width: cardSize,
                  height: cardSize,
                  child: FlipCard(
                    imagePath: card.imagePath,
                    revealed: card.revealed.value,
                    onTap: () => cardController.toggleCard(index),
                  ),
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}

class FlipCard extends StatefulWidget {
  final String imagePath;
  final bool revealed;
  final VoidCallback onTap;

  const FlipCard({
    Key? key,
    required this.imagePath,
    required this.revealed,
    required this.onTap,
  }) : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 350),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (widget.revealed) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revealed != widget.revealed) {
      if (widget.revealed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final value = _animation.value;
          final angle = pi * value;
          final isFront = value > 0.5;

          Widget face = isFront ? _buildFront() : _buildBack();
          if (isFront) {
            face = Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: face,
            );
          }

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: face,
          );
        },
      ),
    );
  }

  Widget _buildBack() {
    return Container(color: const Color.fromARGB(255, 233, 227, 237));
  }

  Widget _buildFront() {
    return Image.asset(widget.imagePath, fit: BoxFit.cover);
  }
}
