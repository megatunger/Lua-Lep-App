class Word {
  int id;
  String img;
  String model;
  String word;

  Word({this.id, this.img, this.model, this.word});

  Word.fromData(Map<String, dynamic> data)
      : id = data["id"],
        img = data["img"],
        model = data["model"],
        word = data["word"];

  Word.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    model = json['model'];
    word = json['word'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['img'] = this.img;
    data['model'] = this.model;
    data['word'] = this.word;
    return data;
  }
}