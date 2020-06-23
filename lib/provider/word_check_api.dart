import 'package:lualepapp/model/word_check.dart';
import 'package:lualepapp/provider/word_check_provider.dart';
class WordCheckApi{
  WordCheckApiProvider _apiProvider = WordCheckApiProvider();

  Future<WordCheck> checkWord(String word, String audioFile){
    return _apiProvider.checkWord(word, audioFile);
  }
}