import 'package:lualepapp/model/sentence_check.dart';
import 'package:lualepapp/provider/sentence_check_api.dart';
import 'package:rxdart/rxdart.dart';

class SentenceCheckBloc {
  final SentenceCheckApi _api = SentenceCheckApi();
  final PublishSubject<SentenceCheck> _sentenceCheckSubject = PublishSubject<SentenceCheck>();

  checkSentence(String word, String audioFile) async {
    SentenceCheck response = await _api.checkSentence(word, audioFile);
    print(response.toJson());
    _sentenceCheckSubject.sink.add(response);
  }

  dispose() {
    _sentenceCheckSubject.close();
  }

  PublishSubject<SentenceCheck> get sentenceCheckSubject  => _sentenceCheckSubject;

}
final sentenceCheckBloc = SentenceCheckBloc();
