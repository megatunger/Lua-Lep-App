class WordCheck {
  String accuracy;
  String message;
  bool passed;
  String word;

  WordCheck({this.accuracy, this.message, this.passed, this.word});

  WordCheck.fromJson(Map<String, dynamic> json) {
    accuracy = json['accuracy'];
    message = json['message'];
    passed = json['passed'];
    word = json['word'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accuracy'] = this.accuracy;
    data['message'] = this.message;
    data['passed'] = this.passed;
    data['word'] = this.word;
    return data;
  }

  WordCheck.fromEmpty() {
    accuracy = "";
    message = "";
    passed = null;
    word = "";
  }
}