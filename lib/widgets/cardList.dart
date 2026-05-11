import 'package:flutter/material.dart';
import 'package:flutter_application_2/controllers/cardController.dart';
import 'package:get/get.dart';

class Breakpoints {
  static const sm = 500;
  static const md = 800;
}

class CardList extends StatelessWidget {
  final CardController cardController = Get.find<CardController>();
  final cards = Get.find<CardController>().cards;

  @override
  Widget build(BuildContext context) {
    final cards = this.cards;
    final cardsList = cards
        .map(
          (card) => Container(
            color: const Color.fromARGB(255, 241, 242, 244),
            child: Center(child: card),
          ),
        )
        .toList();
    final size = MediaQuery.of(context).size;

    return Obx(
      () => GridView.count(
        crossAxisCount: size.width < Breakpoints.sm
            ? 1
            : size.width < Breakpoints.md
            ? 2
            : 3,
        padding: EdgeInsets.all(30),
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        shrinkWrap: true,
        children: cardsList,
      ),
    );
  }
}
