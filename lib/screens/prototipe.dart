import 'package:flutter/material.dart';

class Prototipe extends StatefulWidget {
  const Prototipe({super.key});

  @override
  State<Prototipe> createState() => _PrototipeState();
}

class _PrototipeState extends State<Prototipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white54
                ),
              ),
            ),
            Expanded(child: TextFormField()),
          ],
        ),
      ),
    );
  }
}