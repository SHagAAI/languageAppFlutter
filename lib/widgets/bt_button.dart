import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function callbackFunc;
  const CustomButton(this.callbackFunc, {super.key});

  void triggerTheCallback(){
    callbackFunc();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.purple,
            Colors.deepPurple,
          ],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,

        ),
        onPressed: triggerTheCallback,
        child: const Text("Done"),
      ),
    );
  }
}
