import 'package:objectbox/objectbox.dart';


@Entity()
class WordEntity {
  @Id()
  int id = 0;

  
  String? foreignTerm;
  String? translation;

  final collection = ToOne<WordCollectionEntity>();

  WordEntity({this.foreignTerm, this.translation});
}


@Entity()
class WordCollectionEntity {
  @Id()
  int id = 0;

  
  String collectionName;

  WordCollectionEntity(this.collectionName);

  @Backlink()
  final foreignWord = ToMany<WordEntity>();
}

