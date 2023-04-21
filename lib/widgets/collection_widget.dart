import 'package:flashcard_objbox/objectbox.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:objectbox/objectbox.dart';
import 'package:provider/provider.dart';

import '../models/word_controller.dart';
import '/helper/r.dart';
import '/screens/vocabulary_screen.dart';
import '../models/word_model.dart';

class CollectionWidget extends StatefulWidget {
  final WordCollectionEntity collection;
  // final GlobalKey<AnimatedListState> _keyForDeleting;
  final int wantedIndex;
  const CollectionWidget(
    this.collection,
    this.wantedIndex, {
    Key? key,
  }) : super(key: key);

  @override
  State<CollectionWidget> createState() => _CollectionWidgetState();
}

class _CollectionWidgetState extends State<CollectionWidget> {
  // Box<WordCollectionEntity> collectionBox = objectnyaObjectBox.store.box<WordCollectionEntity>();
  late Store _store;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _store = Provider.of<WordController>(context, listen: false)
          .initializeStore("collection_widget");
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _store.close();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext dialogContext;
    final aniListKey = Provider.of<WordController>(context, listen: false)
        .getGlobalAnimatedListKey;

    return Container(
      padding: const EdgeInsets.only(left: 7),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: R.myColors.cardColor,
        borderRadius: BorderRadius.circular(6),
      ),
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          hoverColor: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            Navigator.of(context).pushNamed(VocabularyScreen.routeName,
                arguments: widget.collection);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.collection.collectionName,
                  style: TextStyle(
                    color: R.myColors.textColorInsideCard,
                    fontSize: 24,
                  ),
                ),
              ),
              IconButton(
                hoverColor: Colors.blueGrey.withOpacity(0.3),
                splashRadius: 20,
                icon: Icon(
                  Icons.delete,
                  color: R.myColors.textColorWhite,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        dialogContext = ctx;
                        return CupertinoAlertDialog(
                          title: Text(
                              "Delete ${widget.collection.collectionName} ?"),
                          content: const Text("Are you sure ?"),
                          actions: [
                            CupertinoDialogAction(
                              child: const Text('Delete'),
                              onPressed: () {
                                bool status = Provider.of<WordController>(ctx,
                                        listen: false)
                                    .deleteCollection(widget.collection);

                                if (status) {
                                  aniListKey.currentState!.removeItem(
                                    widget.wantedIndex,
                                    duration: const Duration(milliseconds: 800),
                                    (context, animation) => SlideTransition(
                                      position: animation.drive(Tween(
                                          begin: const Offset(-2, 0),
                                          end: const Offset(0, 0)).chain(CurveTween(curve: Curves.easeOut))),
                                      child: CollectionWidget(
                                        widget.collection,
                                        widget.wantedIndex,
                                      ),
                                    ),
                                  );

                                  Navigator.of(
                                    dialogContext,
                                    rootNavigator: true,
                                  ).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Collection deleted')),
                                  );
                                }
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                            ),
                          ],
                        ).animate().fadeIn();
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
