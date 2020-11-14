import 'package:lualepapp/model/word_check.dart';
import 'package:lualepapp/provider/word_check_api.dart';
import 'package:lualepapp/utils/ads_helper.dart';
import 'package:rxdart/rxdart.dart';

class WordCheckBloc {
  final WordCheckApi _api = WordCheckApi();
  final PublishSubject<WordCheck> _wordCheckSubject =
      PublishSubject<WordCheck>();

  checkWord(String word, String audioFile) async {
    WordCheck response = await _api.checkWord(word, audioFile);
    AdsHelper.showRewardAd();
    _wordCheckSubject.sink.add(response);
  }

  dispose() {
    _wordCheckSubject.close();
  }

  PublishSubject<WordCheck> get wordCheckSubject => _wordCheckSubject;
}

final wordCheckBloc = WordCheckBloc();
