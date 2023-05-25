import 'package:flashcard_objbox/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MatchCard extends StatefulWidget {
  final WordEntity displayedText;
  final bool isItForeignWord;
  final Function sendForInspection;
  final int indexMyValNotifier;
  final ValueNotifier<int> myValNotifier;
  final Key keyIdentifier;

  const MatchCard({
    super.key,
    required this.displayedText,
    required this.sendForInspection,
    required this.isItForeignWord,
    required this.myValNotifier,
    required this.indexMyValNotifier,
    required this.keyIdentifier,
  });

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard>
    with SingleTickerProviderStateMixin {
  bool selected = false;
  bool? matchStatus;
  int? answerStatus;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Color changeColorHelper() {
    selected = !selected;
    Future.delayed(const Duration(milliseconds: 100));
    _controller.forward().whenComplete(() => _controller.reset());
    return Colors.redAccent;
   
  }

  Color changeColor() {

    setState(() {
      selected = !selected;
    });

    if (selected) {
      
      return Colors.red; 

    } else {

      return Colors.redAccent;

    }
  }

  _onTap() async {
    changeColor();
    // await Future.delayed(Duration(seconds: 1));
    if (selected) {
      answerStatus = widget.myValNotifier.value;
      await widget.sendForInspection();
    }
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: widget.myValNotifier,
      builder: (context, value, child) {
        
        return GestureDetector(
          onTap: widget.myValNotifier.value > 5 ? null : _onTap,
          child: Container(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: selected
                    ? (widget.myValNotifier.value <= 5 &&
                            answerStatus != widget.myValNotifier.value
                        ? changeColorHelper()
                        : Colors.red)
                    : Colors.redAccent,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Center(
                child: Text(
                  widget.isItForeignWord
                      ? widget.displayedText.foreignTerm!
                      : widget.displayedText.translation!,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ).animate(target: widget.myValNotifier.value > 5 ? 1 : 0).scaleXY(
                end: 0, duration: 1.seconds, curve: Curves.fastOutSlowIn),
          ).animate(controller: _controller, autoPlay: false).shake(
                    duration: 500.milliseconds,
                    hz: 40,
                    rotation: 0.017,
                    curve: Curves.fastOutSlowIn
                  ),
        );
      },
    );
  }
}
