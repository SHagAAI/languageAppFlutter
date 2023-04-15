import 'package:flashcard_objbox/models/page_route_helper.dart';
import 'package:flashcard_objbox/models/word_controller.dart';
import 'package:flashcard_objbox/models/word_model.dart';
import 'package:flashcard_objbox/screens/score_screen.dart';
import 'package:flashcard_objbox/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchScreen extends StatefulWidget {
  static const routeName = '/match-screen';
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<WordEntity> matchData = [];
  List<MatchCard> matchCard = [];
  List<Key> stringComparatorHelper = [];
  List<ValueNotifier<int>> myValueNotifierList = [];
  int falseCounter = 0;
  int trueCounter = 0;

  void checkIfMatched(Key myWord) async {
    

    if (stringComparatorHelper.contains(myWord)) {
      stringComparatorHelper.removeWhere((element) => element == myWord);
    } else {
      stringComparatorHelper.add(myWord);
    }

    // print("Ukuruan stringComparator ${stringComparatorHelper.length}");

    if (stringComparatorHelper.length == 2) {
      if (matchCard
              .firstWhere((element) =>
                  element.keyIdentifier == stringComparatorHelper[0])
              .displayedText
              .foreignTerm !=
          matchCard
              .firstWhere((element) =>
                  element.keyIdentifier == stringComparatorHelper[1])
              .displayedText
              .foreignTerm) {
        // Change Value Notifier to tell the combination is wrong
        await Future.delayed(const Duration(milliseconds: 200));
        for (var i = 0; i < 2; i++) {
          var idxWrongCombination = matchCard
              .firstWhere((element) => element.keyIdentifier == stringComparatorHelper[i]).indexMyValNotifier;

          if (myValueNotifierList[idxWrongCombination].value < 5) {
            myValueNotifierList[idxWrongCombination].value += 1;
          } else {
            myValueNotifierList[idxWrongCombination].value -= 4;
          }
        }
        falseCounter += 1;
        stringComparatorHelper.clear();
        // await Future.delayed(const Duration(milliseconds: 500));

        // you have the wrong combination
      } else {
        // YOU GET THE CORRECT ANSWER
        trueCounter += 1;
        for (var i = 0; i < stringComparatorHelper.length; i++) {
          
          int idx = matchCard
              .firstWhere((element) =>
                  element.keyIdentifier == stringComparatorHelper[i])
              .indexMyValNotifier;

          myValueNotifierList[idx].value = 6;
         
        }

        stringComparatorHelper.clear();
        if (trueCounter == 4) {
          
          Navigator.of(context).pushReplacementNamed(ScoreScreen.routeName, arguments: PageRouteHelper("You have $falseCounter wrong attempt", MatchScreen.routeName));
        }

      }
    }


  }

  @override
  void initState() {
    super.initState();
    Provider.of<WordController>(context, listen: false).matchMaking();

    // Fetch data
    matchData =
        Provider.of<WordController>(context, listen: false).getMatchDatas;

    myValueNotifierList.addAll(
        List.generate(matchData.length * 2, (_) => ValueNotifier<int>(0)));


    for (var i = 0; i < 4; i++) {
      Key theWidgetKey = UniqueKey();

      matchCard.add(MatchCard(
        displayedText: matchData[i],
        sendForInspection: () => checkIfMatched(theWidgetKey),
        isItForeignWord: true,
        keyIdentifier: theWidgetKey,
        myValNotifier: myValueNotifierList[(i + i)],
        indexMyValNotifier: (i + i),
      ));

      

      Key theWidgetKeyOtherSide = UniqueKey();

      matchCard.add(MatchCard(
        displayedText: matchData[i],
        sendForInspection: () => checkIfMatched(theWidgetKeyOtherSide),
        isItForeignWord: false,
        keyIdentifier: theWidgetKeyOtherSide,
        myValNotifier: myValueNotifierList[(i + i) + 1],
        indexMyValNotifier: ((i + i) + 1),
      ));

      
    }

    matchCard.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Center(
          child: Container(
            width: 400,
            height: 600,
            padding: const EdgeInsets.only(top: 15),
            child: GridView.builder(
              itemCount: matchCard.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 140,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4),
              itemBuilder: (context, index) {
                return matchCard[index];
              },
            ),
          ),
        ),
      ),
    );
  }
}
