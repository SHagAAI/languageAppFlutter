import 'package:flutter/material.dart';

class QButton extends StatelessWidget {
  const QButton(this.buttonText, this.changePage, {this.usedIcon, super.key});

  final String buttonText;
  final VoidCallback changePage;
  final IconData? usedIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: ElevatedButton(
        onPressed: changePage,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(usedIcon != null)
              Icon(usedIcon),
            Text(buttonText)
          ],
        ),
      ),
    );
  }
}
