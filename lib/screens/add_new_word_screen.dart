import 'package:flashcard_objbox/helper/r.dart';
import 'package:flashcard_objbox/models/word_controller.dart';
import 'package:flashcard_objbox/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

import '../widgets/bt_button.dart';
import '../widgets/text_field_qzlet.dart';

class AddNewWordScreen extends StatefulWidget {
  const AddNewWordScreen({
    super.key,
  });
  static const routeName = '/add-new-word';

  @override
  State<AddNewWordScreen> createState() => _AddNewWordScreenState();
}

class _AddNewWordScreenState extends State<AddNewWordScreen> {
  bool _isInit = true;

  // For displaying existed data
  List<WordEntity> wdList = [];

  // To temporary contained new word
  List<WordEntity> newWordListNeedToAdd = [];
  int counterForExistingData = 0;
  Store? _store;
  WordCollectionEntity? ownedByThisCollection;

  // MultiController Initialization
  var foreignMultiController = <TextEditingController>[];
  var meaningMultiController = <TextEditingController>[];
  var cards = <Card>[];

  @override
  void dispose() {
    super.dispose();
    wdList.clear();

    for (var i = 0; i < foreignMultiController.length; i++) {
      foreignMultiController[i].clear();
      meaningMultiController[i].clear();
    }
  }

  void delete() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      wdList = ModalRoute.of(context)!.settings.arguments as List<WordEntity>;
      for (var i = 0; i < wdList.length; i++) {
        cards.add(createCard(displayedWord: wdList[i], index: i));
      }

      counterForExistingData = wdList.length;
      _store = Provider.of<WordController>(context, listen: false)
          .initializeStore("addNewWord");
      //  Provider.of<WordController>(context, listen: false)
      //     .fetchWord(wdCollection, _store!);

      // Check first, am I succed to get the collection these words belongs to ?
      ownedByThisCollection = wdList[0].collection.target;

      _isInit = false;
    }
  }

  Card createCard({WordEntity? displayedWord, int? index}) {
    TextEditingController fMC = TextEditingController();
    TextEditingController mMC = TextEditingController();

    if (displayedWord != null) {
      fMC.text = displayedWord.foreignTerm!;
      mMC.text = displayedWord.translation!;
    }

    foreignMultiController.add(fMC);
    meaningMultiController.add(mMC);
    return Card(
      margin: EdgeInsets.only(bottom: 18),
      child: Container(
        padding: EdgeInsets.all(10),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                displayedWord != null
                    ? setState(
                        () {
                          bool stat = Provider.of<WordController>(context,
                                  listen: false)
                              .deleteWord(displayedWord);
                          if (stat) {
                            cards.removeAt(index!);
                          }
                        },
                      )
                    : setState(() {
                        cards.removeAt(index!);
                      });
              },
              icon: const Icon(Icons.delete),
            ),
            LayoutBuilder(
              builder: (p0, p1) {
                if (p1.maxWidth <= 850) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFieldQzlet(
                          gC: fMC,
                          fieldTag: "TERM",
                        ),
                        TextFieldQzlet(
                          gC: mMC,
                          fieldTag: "TERM",
                        ),
                      ],
                    ),
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    
                 
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextFieldQzlet(
                          gC: fMC,
                          fieldTag: "TERM",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: TextFieldQzlet(
                          gC: mMC,
                          fieldTag: "TERM",
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void insertMultiple() {
    // Check if there are any changes to the existing datas (Any Update happened)
    for (var i = 0; i < wdList.length; i++) {
      // THis means no changes at the existing data
      if (foreignMultiController[i].text == wdList[i].foreignTerm &&
              meaningMultiController[i].text == wdList[i].translation ||
          foreignMultiController[i].text.isEmpty ||
          meaningMultiController[i].text.isEmpty) {
        continue;
      }

      // Updated data detected. Change the WordEntity object to newer datas

      wdList[i].foreignTerm = foreignMultiController[i].text;
      wdList[i].translation = meaningMultiController[i].text;

      // Add the new value object to the list for updating
      newWordListNeedToAdd.add(wdList[i]);
    }

    // This loop start adding the new data to the list
    for (var i = wdList.length; i < foreignMultiController.length; i++) {
      if (foreignMultiController[i].text.isNotEmpty &&
          meaningMultiController[i].text.isNotEmpty) {
        WordEntity newWord = WordEntity(
            foreignTerm: foreignMultiController[i].text,
            translation: meaningMultiController[i].text);
        newWord.collection.target = ownedByThisCollection;
        newWordListNeedToAdd.add(newWord);
      }
    }

    // List filled by all of the new datas.
    Provider.of<WordController>(context, listen: false).addMultipleNewWord(
        newWordListNeedToAdd, ownedByThisCollection!.id, _store!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 20),
            child: CustomButton(insertMultiple),
          ),
        ],
      ),
      body: Center(
        child: Column(
         
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: ListView.builder(
                  controller: controller,
                  itemCount: cards.length,
                  itemBuilder: (context, index) => cards[index],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    cards.add(createCard(index: cards.length));

                    final contentSize = controller.position.viewportDimension +
                        controller.position.maxScrollExtent;

                    controller.position.animateTo(contentSize,
                        duration: const Duration(seconds: 1),
                        curve: Curves.fastOutSlowIn);
                  });
                },
                child: const Text("Add More"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
