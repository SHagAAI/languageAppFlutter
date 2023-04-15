import 'package:flashcard_objbox/models/page_route_helper.dart';
import 'package:flashcard_objbox/widgets/q_button.dart';
import 'package:flutter/material.dart';


class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});
  static const routeName = '/score-screen';

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageRouteHelper message = ModalRoute.of(context)!.settings.arguments as PageRouteHelper;

    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Container(
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const Text(
                        "🎉",
                        style: TextStyle(fontSize: 100),
                      ),
                      Text(
                        "Congratulations",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                        ),
                      ),
                      Text(
                        message.message,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                QButton("Reset", () {
                  Navigator.of(context).pushReplacementNamed(message.routeNavHelper);
                }),
                SizedBox(
                  height: 10,
                ),
                QButton("Continue", () {
                  Navigator.of(context).pop();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
