import 'package:lualepapp/model/sentence_check.dart';
import 'package:dio/dio.dart';
import 'package:lualepapp/utils/constant.dart';

class SentenceCheckApiProvider{
  final Dio _dio = Dio();

  Future<SentenceCheck> checkSentence(String word, String audioFile) async {
    try {
      print(constant.baseAPI+"/sentence");
      Response response = await _dio.post(constant.baseAPI+"/sentence",
          queryParameters: {
            "word": word,
            "audio_file": audioFile
          }
      );
      return SentenceCheck.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return SentenceCheck.fromEmpty();
    }
  }
}