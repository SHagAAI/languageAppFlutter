import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '/helper/r.dart';
import '/models/word_controller.dart';
import '/models/word_model.dart';

enum DisplaySide { foreignTerm, translation }

class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({super.key});
  static const routeName = '/flashcard-screen';

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  List<WordEntity> flashcardData = [];

  bool _isBack = false;
  double _angle = 0;

  Enum displayedCardSide = DisplaySide.foreignTerm;

  void changeSide() {
    
    setState(() {
      _angle = (_angle + pi) % (2 * pi);
      
    });
  }

  @override
  void initState() {
    super.initState();

    Provider.of<WordController>(context, listen: false)
        .resetFlashcardKnowledge();

    flashcardData =
        Provider.of<WordController>(context, listen: false).wordDatas;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const WordKnowledgeCounter(),
          TweenAnimationBuilder(
            curve: Curves.fastOutSlowIn,
            duration: const Duration(milliseconds: 500),
            tween: Tween<double>(begin: 0, end: _angle),
            builder: (context, val, _) {
              if (val >= (pi / 2) ) {

                _isBack = false;

              } else {

                _isBack = true;

              }
              return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(val as double),
                alignment: Alignment.center,
              child: GestureDetector(
                onTap: changeSide,
                child: Card(
                  color: R.myColors.cardColor,
                  child: Container(
                    width: 340,
                    height: 500,
                    child: Center(
                      child: Consumer<WordController>(
                          builder: (context, value, child) {
                        return _isBack
                            ? Text(
                                flashcardData[value.getFlashCard]
                                    .foreignTerm!)
                            : Transform(
                              transform: Matrix4.identity()..rotateY(pi),
                              alignment: Alignment.center,
                              child: Text(
                                  flashcardData[value.getFlashCard]
                                      .translation!),
                            );
                      }),
                    ),
                  ),
                ),
              ),
            );
            },
          ),
          const ButtonRow(),
        ],
      ),
    );
  }
}

class WordKnowledgeCounter extends StatelessWidget {
  const WordKnowledgeCounter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 50,
          height: 27,
          decoration: BoxDecoration(
              border: Border.all(color: R.myColors.bitterSweet),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )),
          child: Consumer<WordController>(
            builder: (context, value, child) => Text(
              value.getCounterDontKnow.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Container(
          width: 50,
          height: 27,
          decoration: BoxDecoration(
              border: Border.all(color: R.myColors.lawnGreen),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              )),
          child: Consumer<WordController>(
            builder: (context, value, child) => Text(
              value.getCounterKnow.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var knowledge = Provider.of<WordController>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              knowledge.noIDontRemeberThis(context);
            },
            child: Container(
              width: 90,
              child: const Text(
                "Don't Know",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              knowledge.yesIKnowThis(context);
            },
            child: Container(
              width: 90,
              child: const Text(
                "Remember",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
