// ignore_for_file: prefer_const_constructors

import 'package:flashcard_objbox/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';

import '../models/word_controller.dart';
import '../models/word_model.dart';
import '../widgets/collection_widget.dart';
import 'add_new_collection_editor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Store? _stores;
  Query<WordCollectionEntity>? queries;

  @override
  didChangeDependencies() async {
    if (_stores == null) {
      // print("home page accessed");
      _stores = await Provider.of<WordController>(context, listen: false)
          .initializeStore("home1");

      queries = _stores!.box<WordCollectionEntity>().query().build();
    } else if (_stores!.isClosed()) {
      _stores = await Provider.of<WordController>(context, listen: false)
          .initializeStore("home2");

      queries = _stores!.box<WordCollectionEntity>().query().build();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // if (_stores != null) {
    //   _stores!.close();
    // }
    super.dispose();
    queries!.close();
  }

  @override
  Widget build(BuildContext context) {
    // WordController wordC = Provider.of<WordController>(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(18),
            width:
                MediaQuery.of(context).size.width * 0.8, // 80% of the screen size
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              
              children: [
                Text(
                  "🖐🏻 Let's learn some new language",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Collection List",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      //navigate to TASK EDITOR SCREEN
                      icon: const Icon(Icons.add),
                      label: const Text("Add new Collection"),
      
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddNewCollection.routeName);
                      },
                    )
                  ],
                ),
                const Divider(
                  color: Colors.white,
                ),
                Consumer<WordController>(
                  builder: (context, value, child) => SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    
                    child: AnimatedList(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      key: value.getGlobalAnimatedListKey,
                      initialItemCount: value.collectionDatas.length,
                      itemBuilder: (context, index, animation) {
                        
                        return CollectionWidget(
                            value.collectionDatas[index], index);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
