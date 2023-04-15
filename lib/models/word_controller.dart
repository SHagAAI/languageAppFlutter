import 'dart:io';
import 'dart:math';

import 'package:flashcard_objbox/models/page_route_helper.dart';
import 'package:flashcard_objbox/models/word_model.dart';
import 'package:flashcard_objbox/objectbox.g.dart';
import 'package:flashcard_objbox/screens/flashcard_screen.dart';
import 'package:flashcard_objbox/screens/learn_screen.dart';
import 'package:flashcard_objbox/screens/score_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class WordController with ChangeNotifier {
  List<WordEntity> _listWord = [];
  List<WordCollectionEntity> _listCollection = [];
  Store? _store;
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  // bool _isinit = true;

  late final Box<WordCollectionEntity> collectionBox;
  late final Box<WordEntity> wordBox;

  // For Quiz Page
  PageController _pageController = PageController();
  List<int> answersOptionHelper = [];
  Random randomizer = Random();
  List<WordEntity> _questionList = [];
  List<String> _answerOptionWord = [];
  int questionCounterHelper = 0;
  bool _isAnswered = false;
  bool _isItCorrect = false;
  int _correctAnswer = 0;

  // FOR FLASHCARD
  int _iKnowTheWordCounter = 0;
  int _iDontKnowTheWordCounter = 0;
  int _cardIndexPointer = 0;

  // FOR MATCH PAGE
  // List<MatchModel> _matchDataList = [];

  List<ValueNotifier<int>> myValueNotifierList = [];
 

  /*
  /------------/
  Function
  /------------/
  
  */

  // Initializing STORE
  Store initializeStore(String originCalled) {
    Directory paths = Directory("");

    if (_store == null || _store!.isClosed()) {
      

      getApplicationDocumentsDirectory().then((dir) => paths = dir);
      _store = Store(getObjectBoxModel(),
          directory: join(paths.path, 'objectBoxLanguangeApp'));
      // _store = Store(getObjectBoxModel(),
      //     directory: join(paths.path, 'objectboxdbHagi112233'));


      Query<WordCollectionEntity> tempQuery =
          _store!.box<WordCollectionEntity>().query().build();

      _listCollection = tempQuery.find();

     
    } else {
      
      return _store!;
    }

    return _store!;
  }

  void fetchWord(WordCollectionEntity collectionEntity, Store tempStore) {
    if (tempStore.isClosed()) {
      tempStore = initializeStore("fetchWord");
    }

    _listWord = updateListOfWord(collectionEntity.id, tempStore);
  }

  /*
  /------------/
   GETTER function
  /------------/
  
  */

  int get getFlashCard {
    return _cardIndexPointer;
  }

  int get getCounterKnow {
    return _iKnowTheWordCounter;
  }

  int get getCounterDontKnow {
    return _iDontKnowTheWordCounter;
  }

  // To determine the answer is right or wrong
  bool get getAnsweredStatus {
    return _isItCorrect;
  }

  bool get getQuestionsAnsweredStatus {
    return _isAnswered;
  }

  PageController get getPageQuestionController {
    return _pageController;
  }

  List<String> getAnswerOption(int index) {
    questionCounterHelper = index;
    return _answerOptionWord.getRange(index * 4, (index * 4) + 4).toList();
  }

  GlobalKey<AnimatedListState> get getGlobalAnimatedListKey {
    return _animatedListKey;
  }

  List<WordEntity> get wordDatas {
    return [..._listWord];
  }

  List<WordCollectionEntity> get collectionDatas {
    return [..._listCollection];
  }

  List<WordEntity> get getMatchDatas {
    return _questionList;
  }

  /*
  /------------/
  Related to the VOCABULARY
  /------------/
  
  */

  void addCollection(String titleCollection, WordEntity wordObjectToAdded,
      Store tempStore) async {
    if (tempStore.isClosed()) {
      tempStore = initializeStore("addCollection");
    }

    WordCollectionEntity newWordCollection =
        WordCollectionEntity(titleCollection);

    newWordCollection.foreignWord.add(wordObjectToAdded);
    wordObjectToAdded.collection.target = newWordCollection;

    Box<WordCollectionEntity> collectionBox =
        Box<WordCollectionEntity>(tempStore);
    collectionBox.put(newWordCollection);

    _animatedListKey.currentState!
        .insertItem(_listCollection.isEmpty ? 0 : _listCollection.length - 1);
    _listCollection.add(newWordCollection);
    notifyListeners();
    
  }

  void addNewWord(String newWord, String newMeaning,
      WordCollectionEntity collectionTheWordBelongTo, Store tempStore) {
    if (tempStore.isClosed()) {
      tempStore = initializeStore("addNewWord");
    }

    WordEntity newWordToAdd =
        WordEntity(foreignTerm: newWord, translation: newMeaning);
    newWordToAdd.collection.target = collectionTheWordBelongTo;

    tempStore.box<WordEntity>().put(newWordToAdd);
    _listWord.add(newWordToAdd);
    notifyListeners();
  }

  List<WordEntity> updateListOfWord(int collectionId, Store tempStore) {
    Query<WordEntity> tempQueries = tempStore
        .box<WordEntity>()
        .query(WordEntity_.collection.equals(collectionId))
        .build();

    List<WordEntity> tempList = tempQueries.find();
    tempQueries.close();
    return tempList;
  }

  void addMultipleNewWord(List<WordEntity> theMultipleData,
      int idOfTheCollection, Store tempStore) {
    if (tempStore.isClosed()) {
      tempStore = initializeStore("addNewWord");
    }

    tempStore.box<WordEntity>().putMany(theMultipleData);

    // Lets update the content of the list. Easier this way because I dont which is new data and which is update
    // existing data
    _listWord = updateListOfWord(idOfTheCollection, tempStore);

    notifyListeners();
  }

  bool deleteWord(WordEntity intendedWord) {
    if (_store!.isClosed()) {
      _store = initializeStore("deleteCollection");
    }

    bool statusDeleteWord = _store!.box<WordEntity>().remove(intendedWord.id);
    _listWord.removeWhere((element) => element.id == intendedWord.id);
    if (statusDeleteWord) {
      notifyListeners();
      return statusDeleteWord;
    }

    return statusDeleteWord;
  }

  bool deleteCollection(WordCollectionEntity intendedCollection) {
    if (_store!.isClosed()) {
      _store = initializeStore("deleteCollection");
    }

    bool result =
        _store!.box<WordCollectionEntity>().remove(intendedCollection.id);

    _listCollection
        .removeWhere((element) => element.id == intendedCollection.id);

    notifyListeners();
    return result;
  }

  /*
  /------------/
  Related to The Flashcard Pages
  /------------/
  
  */

  void resetFlashcardKnowledge() {
    _iDontKnowTheWordCounter = _iKnowTheWordCounter = _cardIndexPointer = 0;
  }

  void yesIKnowThis(BuildContext cntx) {
    _iKnowTheWordCounter += 1;

    int? idx = nextCard(cntx);
    if (idx != null) {
      _cardIndexPointer = idx;
      notifyListeners();
    }
  }

  void noIDontRemeberThis(BuildContext cntx) {
    _iDontKnowTheWordCounter += 1;

    int? idx = nextCard(cntx);
    if (idx != null) {
      _cardIndexPointer = idx;
      notifyListeners();
    }
  }

  int? nextCard(BuildContext ctx) {
    if (_iDontKnowTheWordCounter + _iKnowTheWordCounter < _listWord.length) {
      return _iDontKnowTheWordCounter + _iKnowTheWordCounter;
    } else {
      
      Navigator.of(ctx).pushReplacementNamed(ScoreScreen.routeName,
          arguments:
              PageRouteHelper("You remember $_iKnowTheWordCounter words and have $_iDontKnowTheWordCounter more words to learn ", FlashCardScreen.routeName));
      return null;
    }
  }

  /*

  /------------/
  Related to The Questions Pages
  /------------/
  
  */

  List<WordEntity> scrambleQ() {
    // Reset counter.
    _correctAnswer = 0;

    _questionList = _listWord;
    _questionList.shuffle();

    makeAnswersOption(_questionList);
    // Take only 70% of the population
    if (_questionList.length >= 10) {
      _questionList =
          _questionList.sublist(0, (_questionList.length * 0.7).round());
    }

    return _questionList;
  }

  void makeAnswersOption(List<WordEntity> amountOfLoopToGenerateOption) {
    List<String> listOptString = [];
    _answerOptionWord.clear();
    List<int> generatedNumber =
        List.generate(amountOfLoopToGenerateOption.length, (index) => index);

    for (var i = 0; i < amountOfLoopToGenerateOption.length; i++) {
      // Generate 3 random option by shuffling the list and take the first 3 element

      do {
        generatedNumber.shuffle();
        answersOptionHelper = generatedNumber.take(3).toList();
      } while (answersOptionHelper.contains(i));

      // Insert the 3 random answer
      for (var c = 0; c < 3; c++) {
        listOptString.add(
            amountOfLoopToGenerateOption[answersOptionHelper[c]].translation!);
      }

      // Insert the correct answer
      listOptString.add(amountOfLoopToGenerateOption[i].translation!);

      // Shuffle the answers collection
      listOptString.shuffle();

      _answerOptionWord.addAll(listOptString);

      listOptString.clear();
    }
  }

  void validateTheAnswer(String answer, WordEntity question) {
    _isAnswered = true;

    if (answer == question.translation) {
      _isItCorrect = true;
      _correctAnswer += 1;
      return;
    }

    _isItCorrect = false;
  }

  void nextQuestionPage(BuildContext ctx) {
    _isAnswered = false;
    if (questionCounterHelper < _questionList.length - 1) {
      _pageController.nextPage(
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    } else {
      Navigator.of(ctx).pushReplacementNamed(ScoreScreen.routeName,
          arguments:
              PageRouteHelper("You have $_correctAnswer correct answer out of ${_questionList.length}", LearnScreen.routeName));
    }
  }

  /*
  
  /------------/
  Related to The Match Pages
  /------------/
  
  */

  void matchMaking() {
    _questionList = _listWord;

    if (_questionList.length <= 4) {
      _questionList.shuffle;
    } else {
      _questionList = _questionList.take(4).toList();
    }
  }

  // This function MUST be called AFTER matchMaking()
  List<ValueNotifier<int>> makeValNotifier() {
    myValueNotifierList.clear();
    myValueNotifierList.addAll(
        List.generate(_questionList.length * 2, (_) => ValueNotifier<int>(0)));


    return myValueNotifierList;
  }


}
