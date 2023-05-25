// ignore_for_file: prefer_const_constructors

import 'package:flashcard_objbox/screens/match_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/word_controller.dart';
import '../helper/r.dart';
import '../models/word_model.dart';
import '../objectbox.g.dart';
import '../widgets/q_button.dart';
import 'learn_screen.dart';
import 'flashcard_screen.dart';
import 'add_new_word_screen.dart';

class VocabularyScreen extends StatefulWidget {
  static const routeName = '/vocabulary-screen';
  // final int collectionId;
  const VocabularyScreen({super.key});

  @override
  State<VocabularyScreen> createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  List<WordEntity> _wordList = [];

  Store? _store;

  bool _isInit = true;
  late WordCollectionEntity idCollection;

  Future<void> _goFetch() async {
    _store =  await Provider.of<WordController>(context, listen: false)
        .initializeStore("vocab1");
    
    Provider.of<WordController>(context, listen: false)
          .fetchWord(idCollection, _store!);

  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_isInit) {
      idCollection =
          ModalRoute.of(context)!.settings.arguments as WordCollectionEntity;

      _store = await Provider.of<WordController>(context, listen: false)
          .initializeStore("vocab1");
      

      Provider.of<WordController>(context, listen: false)
          .fetchWord(idCollection, _store!);

      _isInit = false;
    }
  }

  @override
  void dispose() {
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    WordController wProv = Provider.of<WordController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.only(right: 35),
            child: IconButton(
              icon: const Icon(Icons.add_circle_outline_rounded),
              color: R.myColors.textColorInsideCard,
              onPressed: () {
                Query<WordEntity> fetchWord = _store!
                    .box<WordEntity>()
                    .query(WordEntity_.collection.equals(idCollection.id))
                    .build();
                _wordList = fetchWord.find();
                Navigator.of(context).pushNamed(AddNewWordScreen.routeName,
                    arguments: _wordList);
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(18),

          // width: MediaQuery.of(context).size.width * 0.8, // 80%
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  QButton("Flashcard", () {
                    Navigator.of(context).pushNamed(FlashCardScreen.routeName);
                  }),
                  QButton(
                    "Learn",
                    () {
                      if (wProv.wordDatas.length < 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('You need to atleast have 10 words')),
                        );
                        return;
                      }
                      Navigator.of(context).pushNamed(LearnScreen.routeName);
                    },
                  ),
                  QButton("Match", () {
                    if (wProv.wordDatas.length < 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('You need to atleast have 4 words')),
                      );
                      return;
                    }
                    Navigator.of(context).pushNamed(MatchScreen.routeName);
                  }),
                ],
              ),
              FutureBuilder(
                future: _goFetch(),
                builder: (context, snapshot) {
                  return Consumer<WordController>(
                    builder: (ctx, valueObjBxInt, _) {
                      
                      return DataTable(
                        dataTextStyle: TextStyle(
                            color: R.myColors.textColorInsideCard,
                            letterSpacing: 2),
                        headingTextStyle: TextStyle(
                            color: R.myColors.textColorWhite, letterSpacing: 1),
                        dataRowColor:
                            MaterialStateProperty.resolveWith<Color?>((states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.white;
                          }

                          return null;
                        }),
                        columns: const [
                          DataColumn(label: Text("Word")),
                          DataColumn(label: Text("Meaning")),
                        ],
                        rows: valueObjBxInt.wordDatas
                            .map((e) => DataRow(
                                  cells: [
                                    DataCell(Text("${e.foreignTerm}")),
                                    DataCell(Text("${e.translation}")),
                                  ],
                                ))
                            .toList(),
                      );
                    },
                  );
                },
              ),
              // Consumer<WordController>(
              //   builder: (ctx, valueObjBxInt, _) {
              //     print(
              //         "Size of the current collection ${valueObjBxInt.wordDatas.length}");
              //     return DataTable(
              //       dataTextStyle: TextStyle(
              //           color: R.myColors.textColorInsideCard,
              //           letterSpacing: 2),
              //       headingTextStyle: TextStyle(
              //           color: R.myColors.textColorWhite, letterSpacing: 1),
              //       dataRowColor:
              //           MaterialStateProperty.resolveWith<Color?>((states) {
              //         if (states.contains(MaterialState.hovered)) {
              //           return Colors.white;
              //         }

              //         return null;
              //       }),
              //       columns: const [
              //         DataColumn(label: Text("Word")),
              //         DataColumn(label: Text("Meaning")),
              //       ],
              //       rows: valueObjBxInt.wordDatas
              //           .map((e) => DataRow(
              //                 cells: [
              //                   DataCell(Text("${e.foreignTerm}")),
              //                   DataCell(Text("${e.translation}")),
              //                 ],
              //               ))
              //           .toList(),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
