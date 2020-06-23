import 'package:lualepapp/model/word_check.dart';
import 'package:dio/dio.dart';
import 'package:lualepapp/utils/constant.dart';

class WordCheckApiProvider{
  final Dio _dio = Dio();

  Future<WordCheck> checkWord(String word, String audioFile) async {
    try {
      Response response = await _dio.get(constant.baseAPI, 
          queryParameters: {
            "word": word, 
            "audio_file": audioFile
          }
      );
      return WordCheck.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return WordCheck.fromEmpty();
    }
  }
}