import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/r.dart';
import '../models/word_controller.dart';
import '../models/word_model.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.theQuestion,
    required this.answerList,
  });

  final WordEntity theQuestion;
  final List<String> answerList;

  @override
  Widget build(BuildContext context) {
    var wordProvider = Provider.of<WordController>(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.52,
      height: MediaQuery.of(context).size.height * 0.65,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(245),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            theQuestion.foreignTerm!,
            style: const TextStyle(
              fontSize: 30,
              letterSpacing: 8,
              color: Colors.black,
            ),
          ),
          ...answerList
              .map((e) => AnswersOption(
                  e,
                  () => wordProvider.validateTheAnswer(e, theQuestion),
                  theQuestion))
              .toList()
              .take(4),
        ],
      ),
    );
  }
}

class AnswersOption extends StatefulWidget {
  final String option;
  final WordEntity question;
  final VoidCallback validateMyAnswer;

  const AnswersOption(
    this.option,
    this.validateMyAnswer,
    this.question, {
    super.key,
  });

  @override
  State<AnswersOption> createState() => _AnswersOptionState();
}

class _AnswersOptionState extends State<AnswersOption> {
  WordController? wController;
  Color myColor = R.myColors.grayColor;

  @override
  void initState() {
    super.initState();
    wController = Provider.of<WordController>(context, listen: false);
  }

  void validation() async {
    widget.validateMyAnswer();
    
    setState(() {
      getColor();
    });
    
    Future.delayed(const Duration(seconds: 1)).then((_) => wController!.nextQuestionPage(context));
    
    
  }

  IconData getIcon(){
    return getColor() == R.myColors.greenColor ? Icons.done : Icons.close;
  }

  Color getColor() {
    if (wController!.getQuestionsAnsweredStatus) {
      if (wController!.getAnsweredStatus) {
         
        return R.myColors.greenColor;
      } else {
        
        return R.myColors.redColor;
      }
    }

    return R.myColors.grayColor;
  }

  @override
  Widget build(BuildContext context) {
    
    return InkWell(
      onTap: validation,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          border: Border.all(color: getColor(), width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.option,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                color: getColor() == R.myColors.grayColor ? Colors.transparent : getColor(),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: getColor(),
                ),
              ),
              child: getColor() == R.myColors.grayColor ? null : Icon(getIcon(), size: 16,),
            )
          ],
        ),
      ),
    );
  }
}
