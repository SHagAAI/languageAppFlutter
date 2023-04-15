import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';

import '../models/word_controller.dart';
import '../models/word_model.dart';

class AddNewCollection extends StatefulWidget {
  static const routeName = '/add-collection';
  const AddNewCollection({super.key});

  @override
  State<AddNewCollection> createState() => _AddNewCollectionState();
}

class _AddNewCollectionState extends State<AddNewCollection> {
  final _formKey = GlobalKey<FormState>();
  // Box<WordEntity> wordBox = objectnyaObjectBox.store.box<WordEntity>();
  late Box<WordEntity> wordBox;
   Store? _store;
  // bool _isInit = true;

  final TextEditingController _foreignWordController = TextEditingController();
  final TextEditingController _foreignWordMeaningController =
      TextEditingController();
  final TextEditingController _collectionNameController =
      TextEditingController();

 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // print("sampe sini kah");
    if (_store == null) {
      _store = Provider.of<WordController>(context, listen: false).initializeStore("add_new1");
      // print(_store);
      // _store =  Provider.of<WordController>(context, listen: false).initializeStore();
      wordBox = _store!.box<WordEntity>();
      // _isInit = false;
    } else if (_store!.isClosed()){
      _store = Provider.of<WordController>(context, listen: false).initializeStore("add_new2");
      wordBox = _store!.box<WordEntity>();
    }
   

    
  }

  @override
  void dispose() {
    super.dispose();
    _collectionNameController.dispose();
    _foreignWordController.dispose();
    _foreignWordMeaningController.dispose();
  }

  void addThatNewCollection(
      String titleCollection, WordEntity wordObjectToAdd) {
    // wordBox.addCollection(titleCollection, wordObjectToAdd);
    Provider.of<WordController>(context, listen: false).addCollection(titleCollection, wordObjectToAdd,_store!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Add New Collection"),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name of Your Collection",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _collectionNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: Colors.black26,
                    filled: true,
                    hintStyle: const TextStyle(color: Colors.white24),
                    hintText: "Put name of your collection here ",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Provide name to make new Collection';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                const Text(
                  "Your Word",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _foreignWordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: Colors.black26,
                    filled: true,
                    hintStyle: const TextStyle(color: Colors.white24),
                    hintText: "Put your word here",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'To add new Collection, you need to atleast have one word';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                const Text(
                  "Your Translation",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _foreignWordMeaningController,
                  style: const TextStyle(color: Colors.white),
                  minLines: 5,
                  maxLines: 5,
                  decoration: InputDecoration(
                    fillColor: Colors.black26,
                    filled: true,
                    hintStyle: const TextStyle(color: Colors.white24),
                    hintText: "Translate your word here",
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'I\'m not sure you will remember the meaning of it. Make sure to write it here';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          WordEntity newWordToAdd = WordEntity(
                            foreignTerm: _foreignWordController.text,
                            translation: _foreignWordMeaningController.text,
                          );

                          addThatNewCollection(
                              _collectionNameController.text, newWordToAdd);

                          setState(() {
                            _formKey.currentState!.reset();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                        // taskBox.put(model);

                        // Navigator.pop(context);
                      },
                      color: Colors.blueAccent,
                      elevation: 0.0,
                      child: const Text("Save"),
                    )
                  ],
                ),
              ],
            ),
          ),
         
        ),
      ),
    );
  }
}
