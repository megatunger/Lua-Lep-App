import 'package:lualepapp/model/sentence_check.dart';
import 'package:lualepapp/provider/sentence_check_api_provider.dart';
class SentenceCheckApi{
  SentenceCheckApiProvider _apiProvider = SentenceCheckApiProvider();

  Future<SentenceCheck> checkSentence(String word, String audioFile){
    return _apiProvider.checkSentence(word, audioFile);
  }
}