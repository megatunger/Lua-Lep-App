class SentenceCheck {
  String accuracy;
  String message;
  bool passed;
  List<Words> words;

  SentenceCheck({this.accuracy, this.message, this.passed, this.words});

  SentenceCheck.fromJson(Map<String, dynamic> json) {
    accuracy = json['accuracy'];
    message = json['message'];
    passed = json['passed'];
    if (json['words'] != null) {
      words = new List<Words>();
      json['words'].forEach((v) {
        words.add(new Words.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accuracy'] = this.accuracy;
    data['message'] = this.message;
    data['passed'] = this.passed;
    if (this.words != null) {
      data['words'] = this.words.map((v) => v.toJson()).toList();
    }
    return data;
  }

  SentenceCheck.fromEmpty() {
    this.accuracy = '';
    this.message = '';
    this.passed = false;
    this.words = List();
  }
}

class Words {
  bool passed;
  String word;

  Words({this.passed, this.word});

  Words.fromJson(Map<String, dynamic> json) {
    passed = json['passed'];
    word = json['word'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['passed'] = this.passed;
    data['word'] = this.word;
    return data;
  }
}