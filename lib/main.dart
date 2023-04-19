import 'package:flashcard_objbox/screens/flashcard_screen.dart';
import 'package:flashcard_objbox/screens/match_screen.dart';
import 'package:flashcard_objbox/screens/prototipe.dart';
import 'package:flashcard_objbox/screens/score_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:flashcard_objbox/models/word_controller.dart';
import '/screens/add_new_collection_editor.dart';
import '/screens/add_new_word_screen.dart';
import '/screens/learn_screen.dart';
import '/screens/vocabulary_screen.dart';

import 'package:flashcard_objbox/screens/home_page.dart';
import 'helper/r.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {


  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WordController(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            // useMaterial3: true,
            appBarTheme: AppBarTheme(
              //actionsIconTheme: IconThemeData(color: R.myColors.textColorWhite),
              iconTheme:  IconThemeData(color: R.myColors.textColorWhite),
              toolbarTextStyle: TextStyle(color: R.myColors.textColorInsideCard),
              backgroundColor: R.myColors.bgColor,
              
            ),
            fontFamily: 'OpenSans',
            //iconTheme: IconThemeData(color: R.myColors.textColorWhite),
            scaffoldBackgroundColor: R.myColors.bgColor),
            themeMode: ThemeMode.dark,
            darkTheme: ThemeData( useMaterial3: true, brightness: Brightness.dark),

        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        routes: {
          AddNewCollection.routeName: (context) => const AddNewCollection(),
          VocabularyScreen.routeName: (context) => const VocabularyScreen(),
          AddNewWordScreen.routeName :(context) => const AddNewWordScreen(),
          LearnScreen.routeName :(context) => const LearnScreen(),
          ScoreScreen.routeName :(context) => const ScoreScreen(),
          FlashCardScreen.routeName :(context) => const FlashCardScreen(),
          MatchScreen.routeName :(context) => const MatchScreen(),
        },
      ),
    );
  }
}
