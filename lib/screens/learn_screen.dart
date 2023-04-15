import 'package:flashcard_objbox/models/word_controller.dart';
import 'package:flashcard_objbox/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/question_card.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});
  static const routeName = '/learn-screen';

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  bool _isInit = true;
  List<WordEntity> questionList = [];
  List<String> answerList = [];
  PageController? _pageController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      questionList =
          Provider.of<WordController>(context, listen: false).scrambleQ();
      

      // answerList = Provider.of<WordController>(context, listen: false).getAnswerOption;

      _isInit = false;


    }

  }

  @override
  Widget build(BuildContext context) {
    
    WordController wordProv = Provider.of<WordController>(context, listen: false);
    _pageController = wordProv.getPageQuestionController;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: questionList.length,
            itemBuilder: (context, index) {
              answerList = wordProv.getAnswerOption(index);
              return QuestionCard(theQuestion: questionList[index], answerList: answerList,);
            },
          ),
        ),
      ),
    );
  }
}


