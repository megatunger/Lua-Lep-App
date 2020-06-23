import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lualepapp/model/sentence_model.dart';
import 'package:lualepapp/model/word_model.dart';
import 'package:lualepapp/utils/constant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

class AppDataBloc {
  Query _wordsQuery = constant.database.reference().child("words");
  Query _sentencesQuery = constant.database.reference().child("sentences");

  final PublishSubject<List<Word>> _wordsSubject = PublishSubject<List<Word>>();
  final PublishSubject<List<Sentence>> _sentencesSubject = PublishSubject<List<Sentence>>();

  clearData() async {
    _wordsSubject.sink.add(null);
    _sentencesSubject.add(null);
  }

  refreshData() async {
    getWords();
    getSentences();
  }

  imgUrl(String child, String imageName) async {
    StorageReference ref = FirebaseStorage.instance.ref().child("$child/$imageName");
    try {
      String url = (await ref.getDownloadURL()).toString();
      return url;
    } catch (error) {
      print("Firebase storage error: $error");
      return "https://via.placeholder.com/500";
    }
  }

  getWords() async {
    List<Word> data = List<Word>();
    var snapshot = await _wordsQuery.once();
    for (var element in snapshot.value) {
      if (element!=null) {
        final imageUrl = await imgUrl("words", element["img"]);
        final word = Word(
            id: element["id"],
            img: imageUrl,
            model: element["model"],
            word: element["word"]
        );
        print("Add this word to memory: ${word.toJson()}");
        data.add(word);
      }
    }
    _wordsSubject.sink.add(data);
  }

  getSentences() async {
    List<Sentence> data = List<Sentence>();
    var snapshot = await _sentencesQuery.once();
    for (var element in snapshot.value) {
      if (element!=null) {
        final imageUrl = await imgUrl("sentences", element["img"]);
        final sentence = Sentence(
            id: element["id"],
            img: imageUrl,
            name: element["name"],
            sentence: element["sentence"]
        );
        print("Add this sentence to memory: ${sentence.toJson()}");
        data.add(sentence);
      }
    }
    _sentencesSubject.sink.add(data);
  }

  dispose() {
    _wordsSubject.close();
    _sentencesSubject.close();
  }

  PublishSubject<List<Word>> get wordsSubject => _wordsSubject;
  PublishSubject<List<Sentence>> get sentencesSubject => _sentencesSubject;


}
final appDataBloc = AppDataBloc();